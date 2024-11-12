import SwiftUI

class ExpensesSheetViewModel: ObservableObject {
    @Published var expensesForSave: [ExpenseData]
    @Published var showingAddExpense = false
    @Published var editingExpense: ExpenseData? = nil
    @Published var temporaryImage: UIImage?
    @Published var scannedTotalAmount: Double?
    
    var onSave: (([ExpenseData]) -> Void)?
    var onCancel: (() -> Void)?
    
    init(expenses: [ExpenseData] = [], temporaryImage: UIImage?, scannedTotalAmount: Double? = nil) {
        self.expensesForSave = expenses
        self.temporaryImage = temporaryImage
        self.scannedTotalAmount = scannedTotalAmount
        NSLog("scanned total amount 🪙: \(scannedTotalAmount ?? -1)")
        if self.scannedTotalAmount != nil {
            addExpenseEquilibratingOthers()
        }
    }
    
    func getMostPopularCategory(expenses: [ExpenseData]) -> String {
        var categoryCount: [String: Int] = [:]
        
        // Count occurrences of each category
        for expense in expenses {
            categoryCount[expense.category, default: 0] += 1
        }
        
        // Determine the most popular category
        let popularCategory = categoryCount.max(by: { $0.value < $1.value })?.key
        
        // Return the popular category or "Groceries" if none exists
        return popularCategory ?? "Groceries"
    }
    
    private func addExpenseEquilibratingOthers() {
        guard !self.expensesForSave.isEmpty else {
            NSLog("expenses empty - no need Equilibrating")
            return
        }
        
        // Calculate the current total of existing expenses
        let currentTotal = expensesForSave.reduce(0) { $0 + $1.amount }
        
        // Check if the scanned total amount is not nil and if it does not match the current total
        if let scannedTotal = scannedTotalAmount, scannedTotal != currentTotal {
            // Calculate the difference
            let difference = scannedTotal - currentTotal
            
            // Create a new expense to balance the total
            let balancingExpense = ExpenseData(
                title: "\(AppConfig.adjustCheckTitle) \(scannedTotal)",
                date: expensesForSave.first?.date ?? .now,
                amount: difference,
                currency: expensesForSave.first?.currency ?? .usd,
                category: getMostPopularCategory(expenses: expensesForSave)
            )
            
            // Add the new expense to the expenses array
            expensesForSave.append(balancingExpense)
            NSLog("Added balancing expense: \(balancingExpense)")
        }
        
        // Sort expenses to keep "Check Adjustment" last
        expensesForSave.sort { (expense1, expense2) -> Bool in
            if expense2.category == "Check Adjustment" && expense1.category != "Check Adjustment" {
                return false
            }
            return true
        }
    }
    
    func addExpense() {
        showingAddExpense.toggle()
        editingExpense = nil
    }
    
    func editExpense(_ expense: ExpenseData) {
        editingExpense = expense
        showingAddExpense.toggle()
    }
    
    func deleteExpense(at offsets: IndexSet) {
        expensesForSave.remove(atOffsets: offsets)
    }
    
    func handleSave() {
        onSave?(expensesForSave)
        expensesForSave = []
        scannedTotalAmount = nil
    }
    
    func handleCancel() {
        onCancel?()
        expensesForSave = []
        scannedTotalAmount = nil
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
}
