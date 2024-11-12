import Foundation
import SwiftUI

class AddExpenseViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var title: String = ""
    @Published var date: Date = Date()
    @Published var amount: String = ""
    @Published var currency: Currency = .usd
    @Published var category: String = "Other"
    @Published var temporaryImage: UIImage?
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var showImagePicker = false
    
    // MARK: - Properties
    var expenseToEdit: ExpenseData?
    var onSave: ((ExpenseData) -> Void)?
    
    // MARK: - Initializer
    init(expenseToEdit: ExpenseData? = nil, temporaryImage: UIImage? = nil) {
        self.expenseToEdit = expenseToEdit
        self.temporaryImage = temporaryImage
        loadExpenseData()
    }
    
    // MARK: - Methods
    /// Load existing expense data into the fields if editing
    private func loadExpenseData() {
        if let expense = expenseToEdit {
            title = expense.title
            date = expense.date
            amount = "\(expense.amount)"
            currency = expense.currency
            category = expense.category
        }
    }
    
    /// Save or update the expense after validation
    func saveExpense() {
        guard validateInputs() else { return }  // Early exit if validation fails
        NSLog("Inputs validated ✅")
        
        // Parse amount
        let amountValue = Double(amount.replacingOccurrences(of: ",", with: ".")) ?? 0
        NSLog("Set amount ✅")

        let newExpense = ExpenseData(
            id: expenseToEdit?.id ?? UUID().uuidString,
            title: title,
            date: date,
            amount: amountValue,
            currency: currency,
            category: category
        )
        NSLog("Expense saved")
        onSave?(newExpense)
        
        resetFieldsAfterSave()
    }
    
    /// Validate the fields and set alert messages for missing or invalid data
    private func validateInputs() -> Bool {
        if title.isEmpty {
            alertMessage = "Please enter a title."
            showAlert = true
            return false
        }
        
        if amount.isEmpty || Double(amount.replacingOccurrences(of: ",", with: ".")) == nil {
            alertMessage = "Please enter a valid amount."
            showAlert = true
            return false
        }
        
        if category.isEmpty {
            alertMessage = "Please select a category."
            showAlert = true
            return false
        }
        
        return true
    }
    
    /// Reset fields after saving, if necessary
    private func resetFieldsAfterSave() {
        if expenseToEdit == nil {
            title = ""
            date = Date()
            amount = ""
            currency = .usd
            category = "Groceries"
            temporaryImage = nil
        }
    }
}
