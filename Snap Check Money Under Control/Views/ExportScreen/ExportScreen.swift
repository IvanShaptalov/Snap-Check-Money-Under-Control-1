import SwiftUI
import Lottie


struct ExportScreen: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = ExportViewModel()
    @State private var fileURL: FileURL? = nil
    @State private var alertError: ErrorWrapper?
    @State private var showPayWall = false
    
    struct FileURL: Identifiable {
        let id = UUID()
        let url: URL
    }
    
    private var floatingButton: some View {
        GeometryReader { geometry in
            FloatingActionButton(showActionSheet: $viewModel.showActionSheet, imageName: "square.and.arrow.up")
                .position(x: geometry.size.width - 50, y: geometry.size.height - 100)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Report Details")) {
                    TextField("Report Name", text: $viewModel.reportName)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .submitLabel(.done)
                        .onSubmit {
                            hideKeyboard()
                        }
                }
                Section(header: Text("Properties")) {
                    Picker("Sort By", selection: $viewModel.selectedSortType) {
                        ForEach(ExportSortType.allCases, id: \.self) { sortType in
                            Text(sortType.rawValue)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                Section(header: Text("Date Range")) {
                    HStack {
                        Text("Start Date")
                        Spacer()
                        Text(DateFormatter.localizedString(from: viewModel.startDate, dateStyle: .short, timeStyle: .none))
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text("End Date")
                        Spacer()
                        Text(DateFormatter.localizedString(from: viewModel.endDate, dateStyle: .short, timeStyle: .none))
                            .foregroundColor(.gray)
                    }
                    
                    Button("Select Date Range") {
                        viewModel.showDateSelectionSheet = true
                    }
                }
                
                Section(header: Text("Categories")) {
                    Button("Select Categories") {
                        viewModel.showCategorySelectionSheet = true
                    }
                }
            }
            .navigationTitle("Export Settings")
            .sheet(isPresented: $viewModel.showDateSelectionSheet) {
                DateSelectionSheet(viewModel: viewModel)
            }
            .sheet(isPresented: $viewModel.showCategorySelectionSheet) {
                CategorySelectionSheet(viewModel: viewModel)
            }
            .sheet(isPresented: $viewModel.showActionSheet) {
                exportOrPaywall()
            }
        }
        .overlay(floatingButton
            .opacity(0.9))
        .alert(item: Binding<ErrorWrapper?>.combine($alertError)) { errorWrapper in
            NSLog("alert")
            return Alert(title: Text("Error"), message: Text(errorWrapper.message), dismissButton: .default(Text("OK")))
        }
    }
    
    
    private func exportOrPaywall() -> some View {
        VStack {
            // Добавление сводки с текущими настройками отчета
            VStack(alignment: .leading, spacing: 20) {
                // Заголовок сводки
                Text("📄 Report Summary")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                    .onAppear {
                        AnalyticsManager.shared.logEvent(eventType: .startExport)
                    }
                
                VStack(alignment: .leading, spacing: 16) {
                    // Название отчета
                    HStack(alignment: .center, spacing: 10) {
                        Image(systemName: "doc.text.fill")
                            .foregroundColor(.blue)
                            .font(.title2)
                        Text("Report Name:")
                            .font(.headline)
                            .foregroundColor(.primary)
                        Spacer()
                        Text(viewModel.reportName.isEmpty ? "No name provided" : viewModel.reportName)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                    
                    // Тип сортировки
                    HStack(alignment: .center, spacing: 10) {
                        Image(systemName: "arrow.up.arrow.down.circle.fill")
                            .foregroundColor(.blue)
                            .font(.title2)
                        Text("Sort By:")
                            .font(.headline)
                            .foregroundColor(.primary)
                        Spacer()
                        Text(viewModel.selectedSortType.rawValue)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                    
                    // Категории
                    HStack(alignment: .center, spacing: 10) {
                        Image(systemName: "tag.fill")
                            .foregroundColor(.blue)
                            .font(.title2)
                        Text("Categories:")
                            .font(.headline)
                            .foregroundColor(.primary)
                        Spacer()
                        
                        if viewModel.selectedCategories.isEmpty {
                            Text("None")
                                .font(.body)
                                .foregroundColor(.secondary)
                        } else {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(viewModel.selectedCategories, id: \.self) { category in
                                        Text(category)
                                            .font(.caption)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(Capsule().fill(Color.blue.opacity(0.2)))
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                            
                        }
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGroupedBackground)))
                .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 2)
            }
            .padding([.horizontal, .top])
            
            LottieView {
                try await DotLottieFile.asset(named: "track")
            }
//            .playbackMode(.playing(.toFrame(100, loopMode: .playOnce)))
            .looping()
            .frame(width: 300, height: 200)
            
            Spacer()
            
            if let file = fileURL {
                // Показываем кнопку ShareLink, если есть файл
                if MonetizationConfig.isPremiumAccount {
                    ShareLink(item: file.url) {
                        HStack {
                            Image(systemName: "square.and.arrow.up.fill")
                            Text("Share Report")
                        }
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .onAppear {
                        AnalyticsManager.shared.logEvent(eventType: .exportExpenses)
                    }
                    .padding(.horizontal)
                } else {
                    Button {
                        showPayWall = true
                    } label: {
                        HStack {
                            Image(systemName: "lock.fill")
                            Text("Share Report")
                        }
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }
            } else {
                ProgressView("Exporting...")
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .padding()
            }
        }
        .onAppear {
            let manager = ExpenseExportManager(
                expenseExport: ExpenseExport(
                    reportName: viewModel.reportName,
                    reportStartDate: viewModel.startDate,
                    reportFinishDate: viewModel.endDate,
                    sortType: viewModel.selectedSortType,
                    includedCategories: viewModel.selectedCategories
                )
            )
            
            do {
                // Получаем URL файла
                guard let fileURL = try manager.export(context: modelContext) else {
                    alertError = .init(message: "File not found")
                    return
                }
                self.fileURL = .init(url: fileURL)
                print(self.fileURL?.url ?? "File URL not found")
            } catch {
                alertError = .init(message: "Export failed: \(error.localizedDescription)")
                print("Export failed: \(error)")
            }
        }
        .sheet(isPresented: $showPayWall) {
            PaywallView(subType: AppConfig.rcOfferingIds.first ?? "default")
                .onDisappear {
                    viewModel.showActionSheet = false
                }
        }
        .padding(.bottom, 20)
    }
}


// Sheet для выбора диапазона дат с пресетами
struct DateSelectionSheet: View {
    @ObservedObject var viewModel: ExportViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                List(DatePreset.allCases, id: \.self) { preset in
                    Button(action: {
                        viewModel.setDatePreset(preset)
                        viewModel.showDateSelectionSheet = false
                    }) {
                        Text(preset.rawValue)
                    }
                }
                .navigationTitle("Select Date Preset")
                
                Divider().padding()
                
                DatePicker("Start Date", selection: $viewModel.startDate,in: ...Date(), displayedComponents: .date)
                    .padding()
                DatePicker("End Date", selection: $viewModel.endDate, displayedComponents: .date)
                    .padding()
                
                Button("Done") {
                    viewModel.showDateSelectionSheet = false
                }
                .padding()
                
                Spacer()
            }
        }
    }
}

// Sheet для выбора категорий
struct CategorySelectionSheet: View {
    @ObservedObject var viewModel: ExportViewModel
    
    var body: some View {
        NavigationView {
            List(viewModel.categories, id: \.self) { category in
                HStack {
                    Text(category)
                    Spacer()
                    if viewModel.selectedCategories.contains(category) {
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.toggleCategory(category)
                }
            }
            .navigationTitle("Select Categories")
            .toolbar {
                Button("Done") {
                    viewModel.showCategorySelectionSheet = false
                }
            }
        }
    }
}

