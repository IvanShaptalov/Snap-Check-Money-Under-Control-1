import SwiftUI

struct ExpenseCategorySettingsView: View {
    @State private var categories = AppConfig.getBasicCategories()
    @State private var newCategory: String = ""
    @State private var isShowingAddCategorySheet = false

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Manage Categories")) {
                    ForEach(categories, id: \.self) { category in
                        HStack {
                            Text(category)
                            Spacer()
                            if category != "Other" {
                                Button(action: {
                                    if let index = categories.firstIndex(of: category) {
                                        categories.remove(at: index)
                                        updateAppConfiguration()
                                    }
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                      
                                }
                            }
                        }
                    }
                    .onDelete(perform: deleteCategory)
                }
            }
            .navigationTitle("Categories")
            .navigationBarItems(trailing: Button(action: {
                isShowingAddCategorySheet = true
            }) {
                Text("Add Category")
            })
            .sheet(isPresented: $isShowingAddCategorySheet) {
                AddCategoryView(categories: $categories, newCategory: $newCategory, isPresented: $isShowingAddCategorySheet)
            }
        }
    }

    private func deleteCategory(at offsets: IndexSet) {
        categories.remove(atOffsets: offsets)
        updateAppConfiguration()
    }

    private func updateAppConfiguration() {
        AppConfig.setBasicCategories(categories)
        print("new categories 🍪 \(AppConfig.getBasicCategories())")
    }
}

struct AddCategoryView: View {
    @Binding var categories: [String]
    @Binding var newCategory: String
    @Binding var isPresented: Bool

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("New Category")) {
                    TextField("Enter category name", text: $newCategory)
                    Button(action: addCategory) {
                        Text("Add")
                    }
                    .disabled(newCategory.isEmpty || categories.contains(newCategory))
                }
            }
            .navigationTitle("Add Category")
            .navigationBarItems(trailing: Button("Done") {
                addCategory()
                isPresented = false
                
            })
        }
    }

    private func addCategory() {
        if !newCategory.isEmpty && !categories.contains(newCategory) {
            categories.append(newCategory)
            updateAppConfiguration()
            newCategory = ""
            isPresented = false
            AnalyticsManager.shared.logEvent(eventType: .categoriesEdited)
        }
    }

    private func updateAppConfiguration() {
        AppConfig.setBasicCategories(categories)
    }
}
