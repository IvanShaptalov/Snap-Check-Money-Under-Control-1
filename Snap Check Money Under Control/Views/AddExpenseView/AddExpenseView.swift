import SwiftUI

struct AddExpenseView: View {
    @ObservedObject var viewModel: AddExpenseViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                expenseDetailsSection
                receiptImageSection
            }
            .navigationTitle(viewModel.expenseToEdit == nil ? "Add Expense" : "Edit Expense")
            .navigationBarItems(
                leading: Button("Cancel") {
                    AnalyticsManager.shared.logEvent(eventType: .checkEditedCancelled)

                    presentationMode.wrappedValue.dismiss()
                }
                    .frame(width: 44, height: 44), // Увеличьте размер кнопки,
                trailing: Button("Save") {
                    viewModel.saveExpense()
                    AnalyticsManager.shared.logEvent(eventType: .checkEditedSaved)

                }
                    .frame(width: 44, height: 44) // Увеличьте размер кнопки
            )
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Invalid Input"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
            }
            .sheet(isPresented: $viewModel.showImagePicker) {
                ImagePicker(image: $viewModel.temporaryImage, sourceType: .photoLibrary)
            }
            .onAppear {
                AnalyticsManager.shared.logEvent(eventType: .checkEdited)
            }
        }
    }
    
    private var expenseDetailsSection: some View {
        Section(header: Text("Expense Details")) {
            TextField("Title", text: $viewModel.title)
            TextField("Amount", text: $viewModel.amount)
                .keyboardType(.decimalPad)
            Picker("Currency", selection: $viewModel.currency) {
                ForEach(Currency.allCases, id: \.self) { currency in
                    Text(currency.description).tag(currency)
                }
            }
            Picker("Category", selection: $viewModel.category) {
                ForEach(AppConfig.getBasicCategories(), id: \.self) { category in
                    Text(category).tag(category)
                }
            }
            .pickerStyle(MenuPickerStyle())
            DatePicker("Date", selection: $viewModel.date, in: ...Date(), displayedComponents: .date)
                .datePickerStyle(.compact)
        }
    }
    
    private var receiptImageSection: some View {
        Section(header: Text("Receipt Image")) {
            Button("Choose Photo") {
                viewModel.showImagePicker = true
            }
            
            if let image = viewModel.temporaryImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width)
            } else {
                Text("No image selected")
                    .foregroundColor(.gray)
            }
        }
    }
}


