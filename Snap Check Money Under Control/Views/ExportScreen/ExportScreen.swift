import SwiftUI


import SwiftUI

struct ExportScreen: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = ExportViewModel()
    @State private var fileURL: FileURL? = nil
    @State private var alertError: ErrorWrapper?

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
                    Picker("Format", selection: $viewModel.selectedExportFormat) {
                        ForEach(ExportFormat.allCases, id: \.self) { sortType in
                            Text(sortType.rawValue)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())

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
                VStack {
                    if let file = fileURL{
                        // Безопасно извлекаем и показываем ShareLink, если fileURL не nil
                        ShareLink(item: file.url) {
                            VStack {
                                Spacer()
                                Text("Share Report")
                                    .bold()
                                    .frame(maxWidth: UIScreen.main.bounds.width * 0.8)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    } else {
                        ProgressView()
                    }
                }
                .onAppear {
                    let manager = ExpenseExportManager(
                        expenseExport: .init(
                            reportName: viewModel.reportName,
                            reportStartDate: viewModel.startDate,
                            reportFinishDate: viewModel.endDate,
                            sortType: viewModel.selectedSortType,
                            exportFormat: viewModel.selectedExportFormat,
                            includedCategories: viewModel.categories
                        )
                    )

                    do {
                        // Получаем URL файла
                        guard let fileURL = try manager.export(context: modelContext) else {
                            alertError = .init(message: "File not found")
                            return
                        }

                        // Сохраняем файл URL в состоянии
                        self.fileURL = .init(url: fileURL)
                        print(self.fileURL?.url ?? "File URL not found")
                    } catch {
                        alertError = .init(message: "Export failed: \(error.localizedDescription)")
                        print("Export failed: \(error)")
                    }
                }
            }
        }
        .overlay(floatingButton
            .opacity(0.9))
        .alert(item: Binding<ErrorWrapper?>.combine($alertError)) { errorWrapper in
            NSLog("alert")
            return Alert(title: Text("Error"), message: Text(errorWrapper.message), dismissButton: .default(Text("OK")))
        }
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

