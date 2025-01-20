import SwiftUI

struct ExpensesSheetView: View {
    @ObservedObject var viewModel: ExpensesSheetViewModel

    @State private var alertAjustingMessage: ErrorWrapper?
    
    @State private var alertExpensesInOtherYear: ErrorWrapper?
    
    
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.expensesForSave.isEmpty {
                    Spacer()
                    
                    VStack {
                        // Используем Image с плейсхолдером
                        Image(systemName: "note.text") // Замените на системное имя изображения по умолчанию
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                            .foregroundStyle(.gray)
                            .opacity(0.9)
                        
                        Button(action: {
                            viewModel.addExpense()
                        }) {
                            Text("Add new Expense")
                                .font(.title3)
                                .fontWeight(.medium)
                                .padding(.top)
                                .foregroundColor(.blue) // Добавляет цвет текста кнопки
                        }
                    }
                    
                    Spacer()
                } else {
                    List {
                        ForEach(viewModel.expensesForSave) { expense in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(expense.title)
                                        .font(.headline)
                                    Text("\(expense.amount, specifier: "%.2f") \(expense.currency.rawValue)")
                                    Text(expense.category)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    Text("\(expense.date, formatter: viewModel.dateFormatter)")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                if let tmpImg = viewModel.temporaryImage {
                                    Image(uiImage: tmpImg)
                                        .resizable()
                                        .frame(width: 70, height: 70)
                                        .clipShape(.buttonBorder)
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                if expense.title.contains(AppConfig.adjustCheckTitle) {
                                    showAdjustmentAlert()
                                } else {
                                    viewModel.editExpense(expense)
                                }
                            }
                        }
                        .onDelete(perform: viewModel.deleteExpense)
                    }
                }
                
                HStack {
                    Button(action: {
                        viewModel.handleCancel()
                        AnalyticsManager.shared.logEvent(eventType: .creatingCheckCancelled)
                    }) {
                        Text("Cancel")
                            .font(.headline) // Установите шрифт
                            .padding()
                            .frame(width: 150) // Устанавливаем фиксированную ширину
                            .background(Color.red.opacity(0.2)) // Полупрозрачный фон
                            .foregroundColor(.red) // Цвет текста
                            .cornerRadius(8) // Закругление углов
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.red, lineWidth: 2) // Обводка
                            )
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        let isOtherYear = viewModel.checkExpensesInOtherThatCurrentYear()
                        if isOtherYear {
                            alertExpensesInOtherYear = ErrorWrapper(message: "Some of the Expenses will be added to other year, not \(Date.currentYear())")
                        } else {
                            viewModel.handleSave()
                        }
                    }) {
                        Text("Save")
                            .font(.headline) // Установите шрифт
                            .padding()
                            .frame(width: 150) // Устанавливаем фиксированную ширину
                            .background(Color.blue.opacity(0.2)) // Полупрозрачный фон
                            .foregroundColor(.blue) // Цвет текста
                            .cornerRadius(8) // Закругление углов
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.blue, lineWidth: 2) // Обводка
                            )
                    }
                }
                .padding()
            }
            .navigationTitle("Expenses: \(totalAmount(), specifier: "%.2f") \((viewModel.expensesForSave.first?.currency ?? AppConfig.mainCurrency).rawValue)")
            .navigationBarItems(leading: Button(action: {
                viewModel.updateDates()
            }) {
                Text("Set as Today")
            },trailing: HStack {
                // Кнопка Apply с отображением валюты
                Button(action: {
                    viewModel.updateCurrency()
                }) {
                    Text("Apply \(AppConfig.mainCurrency.description)")
                }
                
                Button(action: {
                    viewModel.addExpense()
                }) {
                    Image(systemName: "plus")
                        .imageScale(.large)
                        .frame(width: 44, height: 44) // Увеличьте размер кнопки
                }
                
            })
        }
        .sheet(isPresented: $viewModel.showingAddExpense) {
            // Initialize AddExpenseViewModel with the necessary data
            let expViewModel = AddExpenseViewModel(
                expenseToEdit: viewModel.editingExpense,
                temporaryImage: viewModel.temporaryImage
            )
            
            // Set the onSave closure to handle adding or updating the expense
            expViewModel.onSave = { expense in
                if let index = viewModel.expensesForSave.firstIndex(where: { $0.id == expense.id }) {
                    // Update existing expense if it exists in the list
                    viewModel.expensesForSave[index] = expense
                } else {
                    // Append new expense if it doesn't exist in the list
                    viewModel.expensesForSave.append(expense)
                }
                
                // Dismiss the sheet
                viewModel.showingAddExpense = false
            }
            
            // Present AddExpenseView with the configured ViewModel
            return AddExpenseView(viewModel: expViewModel)
        }

        .alert(item: Binding<ErrorWrapper?>.combine($alertAjustingMessage, $alertExpensesInOtherYear)) { errorWrapper in
            NSLog("alert")
            if errorWrapper.message == alertExpensesInOtherYear?.message {
                return Alert(title: Text("Info"), message: Text(errorWrapper.message), dismissButton: .default(Text("OK"), action: viewModel.handleSave))
            }
            return Alert(title: Text("Info"), message: Text(errorWrapper.message), dismissButton: .default(Text("OK")))
        }
    }
    
    func showAdjustmentAlert() {
        if viewModel.scannedTotalAmount != nil {
            alertAjustingMessage = ErrorWrapper(message:"This adjustment is to make sure the total amount matches what you scanned. The scanned amount is \(viewModel.scannedTotalAmount ?? totalAmount()). The amounts for the individual items may not add up exactly, so we add this adjustment to correct it.")
        }
    }
    
    func totalAmount() -> Double {
        return viewModel.expensesForSave.reduce(0) { $0 + $1.amount }
    }
}
