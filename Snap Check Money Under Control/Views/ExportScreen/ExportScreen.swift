import SwiftUI


struct ExportScreen: View {
    @StateObject private var viewModel = ExportViewModel()
    
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
                }
                
                Section(header: Text("Sort Options")) {
                    Picker("Sort Type", selection: $viewModel.selectedSortType) {
                        ForEach(ExportSortType.allCases, id: \.self) { sortType in
                            Text(sortType.rawValue)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
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
                Text("Export")
            }
            
            .overlay(floatingButton)
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
                DatePicker("End Date", selection: $viewModel.endDate,in: ...Date(), displayedComponents: .date)
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
