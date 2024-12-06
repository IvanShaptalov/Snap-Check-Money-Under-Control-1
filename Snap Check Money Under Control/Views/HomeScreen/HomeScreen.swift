import SwiftUI
import Charts

struct HomeScreen: View {
    @StateObject private var textRecognitionVM = TextRecognitionViewModel()
    @EnvironmentObject var chatVM: ChatViewModel
    @StateObject var homeScreenVM = HomeScreenViewModel()
    private let jsonDecoder = JsonDecoder()
    @State var tmpExpensesForCreating: [ExpenseData] = []
    @State var scannedTotalAmount: Double?
    @Environment(\.modelContext) private var modelContext
    @StateObject var expenseManagerVM = ExpenseManagerViewModel()
    @State var tmpExpensesFromJson: [ExpenseData] = []
    @State private var intAdsVm = InterstitialViewModel()
    @State var expenses: [ExpenseData] = [
    ].sorted(by: { $0.date > $1.date })
    @State private var showInterstitialAds = false
    var totalSpent: Double {
        withAnimation {
            expenses.map { $0.amount }.reduce(0, +)
        }
    }
    
    private var imagePickerView: some View {
        ImagePicker(image: $homeScreenVM.inputImage, sourceType: homeScreenVM.sourceType)
    }
    
    
    
    var body: some View {
        VStack {
            
            MonthOrYearSpents(isShowYear: $homeScreenVM.isShowYear, totalSpent: totalSpent)
            
            PieChart(expenses: expenses)
                .frame(width: UIScreen.main.bounds.width * 0.8 ,height: UIScreen.main.bounds.height * 0.22, alignment: .center)
                
            ExpenseListView(expenses: $expenses) { expense in
                editExpense(expense)
            } onDeleteExpense: { expenseToDelete in
                deleteExpense(expenseToDelete)
            }
        }.overlay(
            floatingButton
                .opacity(0.9)
        )
        .onAppear {
            loadExpenses()
            NotificationManager.requestNotificationPermission()
        }
        .task {
            await intAdsVM.loadAdRecursively()
        }
        .actionSheet(isPresented: $homeScreenVM.showActionSheetFromCreating) {
            actionSheetCheckAdding
        }
        .sheet(isPresented: $homeScreenVM.showImagePicker) {
            imagePickerView
        }
        .sheet(isPresented: $homeScreenVM.showCreateExpenceSheet) {
            expenseSheetFromCreating.onDisappear {
                NSLog("creating view sheet dissapeared")
                cleanResourses()
            }
            .onAppear{
                loadExpenses()
            }
        }
        .sheet(isPresented: $homeScreenVM.showActionSheetFromJson) {
            expenseSheetFromJson.onDisappear {
                NSLog("json view sheet dissapeared")
                cleanResourses()
                let rand = Int.random(in: 0...10)
                if rand == 7 || rand == 3 {
                    NSLog("review 🤌")
                    ReviewService.requestReview()
                } else {
                    if showInterstitialAds {
                        NSLog("ads 🤮")
                        intAdsVm.showAndLoadNextAd()
                    } else {
                        NSLog("review 🤌")
                        ReviewService.requestReview()
                    }
                }
                
            }
            .onAppear{
                loadExpenses()
                AnalyticsManager.shared.logEvent(eventType: .homeScreen)
            }
        }
        .onChange(of: homeScreenVM.inputImage) { previousImage, newImage in
            withAnimation {
                processRecognizedImage(newImage, in: textRecognitionVM, using: chatVM)
            }
        }
        .onChange(of: chatVM.resultResponse) { _, newResult in
            withAnimation {
                decodeAndAddExpenses(from: newResult, to: &expenses)
                
            }
        }
        .onChange(of: homeScreenVM.isShowYear) {_, newYear in
            loadExpenses()
        }
        .alert(item: Binding<ErrorWrapper?>.combine($chatVM.errorMessage, $textRecognitionVM.errorMessage)) { errorWrapper in
            NSLog("alert")
            return Alert(title: Text("Error"), message: Text(errorWrapper.message), dismissButton: .default(Text("OK")))
        }
        
    }
    
    func loadExpenses() {
        expenses = expenseManagerVM.loadExpenses(modelContext: modelContext, dateRange: AppConfig.showYearFormat ? .currentYear : .currentMonth).sorted(by: {$0.date > $1.date})
    }
    
    func decodeAndAddExpenses(from newResult: ChatGPTRequest.ChatMessage?, to expenses: inout [ExpenseData]) {
        // Ensure that newResult exists and contains content
        guard let resultContent = newResult?.content else {
            NSLog("Нет контента в resultResponse")
            return
        }
        
        // Convert the content string to data
        if let resultData = resultContent.data(using: .utf8) {
            // Decode the data into ExpenseReport
            let decoder = JSONDecoder()
            do {
                // Decode into ExpenseReport
                let expenseReport = try decoder.decode(ExpenseReport.self, from: resultData)
                
                // Convert ExpenseReport to an array of Expense
                let newExpenses = expenseReport.items.map { item in
                    ExpenseData(title: item.title, date: expenseReport.date, amount: item.price, currency: Currency.from(string: expenseReport.currency), category: item.category)
                }
                scannedTotalAmount = expenseReport.totalPrice
                // Add new expenses to editing and show action sheet
                tmpExpensesFromJson = newExpenses
                homeScreenVM.showActionSheetFromJson = true
                NSLog("Расходы успешно декодированы и добавлены: \(newExpenses)")
            } catch {
                NSLog("Ошибка декодирования данных: \(error)")
            }
        } else {
            NSLog("Ошибка преобразования строки в данные")
        }
    }
    
    func addOrUpdateExpenses(_ newExpenses: [ExpenseData]) {
        expenseManagerVM.addOrUpdateExpense(newExpenses, modelContext: modelContext)
        loadExpenses()
    }
    
    func processRecognizedImage(_ newImage: UIImage?, in textRecognitionVM: TextRecognitionViewModel, using chatVM: ChatViewModel) {
        guard let inputImage = newImage else { return }
        
        textRecognitionVM.recognizeText(from: inputImage) // Recognize text from image
        NSLog("recognized")
        chatVM.isLoading = false
        DispatchQueue.main.async {
            if textRecognitionVM.errorMessage == nil {
                let role = "user"
                let chatMessage = ChatGPTRequest.ChatMessage(role: role, content: Prompts.preparePrompt(textRecognitionVM.recognizedText))
                chatVM.addMessage(chatMessage) // Send recognized text to ChatGPT
            }
        }
        
    }
    
    private var floatingButton: some View {
        GeometryReader { geometry in
            if chatVM.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .frame(width: 60, height: 60) // Размер ProgressView
                    .background(Color.blue) // Цвет фона
                    .clipShape(Circle()) // Круглая форма
                    .shadow(radius: 5) // Тень для эффекта подъема
                    .position(x: geometry.size.width - 50, y: geometry.size.height - 100) // Позиционирование
            } else {
                FloatingActionButton(showActionSheet: $homeScreenVM.showActionSheetFromCreating) // Кнопка
                    .position(x: geometry.size.width - 50, y: geometry.size.height - 100) // Позиционирование
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Занять всё пространство
    }
    
    private var actionSheetCheckAdding: ActionSheet {
        ActionSheet(title: Text("New Expense"), message: nil, buttons: [
            .default(Text("Camera")) {
                homeScreenVM.sourceType = .camera
                homeScreenVM.showImagePicker = true
                AnalyticsManager.shared.logEvent(eventType: .createCheckFromCamera)

            },
            .default(Text("Photo Library")) {
                homeScreenVM.sourceType = .photoLibrary
                homeScreenVM.showImagePicker = true
                AnalyticsManager.shared.logEvent(eventType: .createCheckFromLibrary)

            },
            .default(Text("Create Manually")) {
                homeScreenVM.showCreateExpenceSheet = true
                AnalyticsManager.shared.logEvent(eventType: .createCheckManually)
            },
            .cancel()
        ])
    }
    
    private func hideCreatingSheet() {
        tmpExpensesForCreating = []
        tmpExpensesFromJson = []
        homeScreenVM.showCreateExpenceSheet = false
        homeScreenVM.showActionSheetFromJson = false
        scannedTotalAmount = nil
    }
    
    private func deleteExpense(expense: ExpenseData) {
        expenseManagerVM.deleteExpense(by: expense.id, modelContext: modelContext)
    }
    
    private var expenseSheetFromCreating: ExpensesSheetView {
        let viewModel = ExpensesSheetViewModel(expenses: tmpExpensesForCreating,
                                               temporaryImage: homeScreenVM.inputImage)
        viewModel.onSave = { newExpenses in
            addOrUpdateExpenses(newExpenses)
            hideCreatingSheet()
        }
        
        viewModel.onCancel = {
            hideCreatingSheet()
        }
        
        // Then, pass the ViewModel to the `ExpensesSheetView`:
        return ExpensesSheetView(viewModel: viewModel)
    }
    
    private var expenseSheetFromJson: ExpensesSheetView {
        let viewModel = ExpensesSheetViewModel(expenses: tmpExpensesFromJson,
                                               temporaryImage: homeScreenVM.inputImage,
                                               scannedTotalAmount: scannedTotalAmount)
        viewModel.onSave = { newExpenses in
            addOrUpdateExpenses(newExpenses)
            hideCreatingSheet()
            showInterstitialAds = true

        }
        
        viewModel.onCancel = {
            hideCreatingSheet()
            showInterstitialAds = true

        }
        
        // Pass the ViewModel to the `ExpensesSheetView`
        return ExpensesSheetView(viewModel: viewModel)
    }
    
    private func editExpense(_ expense: ExpenseData) {
        NSLog("add expence to edit: \(expense)")
        tmpExpensesFromJson = [expense]
        homeScreenVM.showActionSheetFromJson = true
    }
    
    private func deleteExpense(_ expense: ExpenseData) {
        expenses.removeAll { $0.id == expense.id }
        expenseManagerVM.deleteExpense(by: expense.id, modelContext: modelContext)
    }
    
    fileprivate func cleanResourses() {
        NSLog("clean resourses 🧹 scannedTotalAmount, tmp from json, tmp from creating")
        scannedTotalAmount = nil
        tmpExpensesFromJson = []
        tmpExpensesForCreating = []
        homeScreenVM.inputImage = nil
    }
}

#Preview {
    HomeScreen()
}
