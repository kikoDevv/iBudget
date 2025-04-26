//
//  ContentView.swift
//  iBudget
//
//  Created by Kiko on 2023-03-02.
//

import SwiftUI

struct ExpenseCategory: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let icon: String // SF Symbol name or emoji
}

let predefinedCategories: [ExpenseCategory] = [
    ExpenseCategory(name: "Rent", icon: "house.fill"),
    ExpenseCategory(name: "Insurance", icon: "shield.fill"),
    ExpenseCategory(name: "Fitness", icon: "figure.strengthtraining.traditional"),
    ExpenseCategory(name: "Electricity", icon: "bolt.fill"),
    ExpenseCategory(name: "Food", icon: "cart.fill"),
    ExpenseCategory(name: "Car", icon: "car.fill"),
    ExpenseCategory(name: "Phone", icon: "iphone.gen3"),
    ExpenseCategory(name: "Internet", icon: "wifi"),
    ExpenseCategory(name: "Transportation", icon: "bus.fill"),
    ExpenseCategory(name: "Healthcare", icon: "cross.case.fill"),
    ExpenseCategory(name: "Entertainment", icon: "film.fill"),
    ExpenseCategory(name: "Shopping", icon: "bag.fill"),
    ExpenseCategory(name: "Education", icon: "book.fill"),
    ExpenseCategory(name: "Travel", icon: "airplane"),
    ExpenseCategory(name: "Pets", icon: "pawprint.fill"),
    ExpenseCategory(name: "Gifts", icon: "gift.fill"),
    ExpenseCategory(name: "Subscriptions", icon: "creditcard.fill"),
    ExpenseCategory(name: "Savings", icon: "banknote.fill"),
    ExpenseCategory(name: "Other", icon: "ellipsis.circle.fill")
]

struct ContentView: View {
    // MARK: - State Variables
    @State private var expenses = UserDefaults.standard.object(forKey: "listan") as? [String:Int] ?? [String:Int]()
    @State private var income: Float = UserDefaults.standard.float(forKey: "inkomst")
    @State private var showMainView = false
    @State private var showSecondView = true
    @State private var showEditView = false
    @State private var showAddView = false
    @State private var inputKey = ""
    @State private var inputValue = ""
    @State private var animationEffect = false

    // MARK: - Computed Properties
    private var totalExpenses: Int {
        expenses.values.reduce(0, +)
    }

    private var savings: Int {
        Int(income) - totalExpenses
    }

    private var yearlySavings: Int {
        savings * 12
    }

    var body: some View {
        Group {
            if showMainView {
                WelcomeView(income: $income, showMainView: $showMainView, showSecondView: $showSecondView)
            } else if showSecondView {
                BudgetView(
                    income: $income,
                    expenses: expenses,
                    showEditView: $showEditView,
                    showAddView: $showAddView,
                    inputKey: $inputKey,
                    inputValue: $inputValue,
                    onDelete: deleteExpense,
                    onSave: saveExpense
                )
            }
        }
    }

    // MARK: - Helper Methods
    private func saveExpense() {
        if let value = Int(inputValue) {
            expenses[inputKey] = value
            UserDefaults.standard.set(expenses, forKey: "listan")
            inputKey = ""
            inputValue = ""
            showAddView = false
        }
    }

    private func deleteExpense(at offsets: IndexSet) {
        if let index = offsets.first {
            let item = expenses.sorted { $0.1 > $1.1 }[index]
            expenses.removeValue(forKey: item.key)
            UserDefaults.standard.set(expenses, forKey: "listan")
        }
    }
}

// MARK: - Welcome View
struct WelcomeView: View {
    @Binding var income: Float
    @Binding var showMainView: Bool
    @Binding var showSecondView: Bool
    @State private var animationEffect = false

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            // Background circles
            Circle()
                .foregroundColor(Color.blue.opacity(0.4))
                .padding(-150)
            Circle()
                .foregroundColor(Color.blue.opacity(0.6))
                .padding(-90)
            Circle()
                .foregroundColor(Color.blue)
                .padding(-20)
                .shadow(radius: 10)
            Circle()
                .scale(animationEffect ? 3 : 0)
                .offset(y: 100)
                .foregroundColor(Color.black)

            VStack {
                Text("Welcome")
                    .scaleEffect(animationEffect ? 0 : 1)
                Text(income == 0 ? "Set your income" : "\(Int(income)) kr")
                    .scaleEffect(animationEffect ? 0 : 1)
                    .font(.largeTitle)
                    .padding(1)

                Slider(value: $income, in: 0...70000, step: 500)
                    .scaleEffect(animationEffect ? 0 : 1)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 30)

                Button("Start") {
                    UserDefaults.standard.set(income, forKey: "inkomst")
                    withAnimation {
                        animationEffect = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        showMainView = false
                        showSecondView = true
                    }
                }
                .scaleEffect(animationEffect ? 0 : 1)
                .padding(10)
                .foregroundColor(.white)
                .background(Color.black)
                .cornerRadius(20)
                .padding(.bottom, 10)
            }
        }
    }
}

// MARK: - Budget View
struct BudgetView: View {
    @Binding var income: Float
    let expenses: [String:Int]
    @Binding var showEditView: Bool
    @Binding var showAddView: Bool
    @Binding var inputKey: String
    @Binding var inputValue: String

    let onDelete: (IndexSet) -> Void
    let onSave: () -> Void

    var body: some View {
        NavigationView {
            ZStack {
                List {
                    Section(header: Text("Budget")) {
                        BudgetSummaryView(income: income, expenses: expenses)
                    }

                    Section(header: Text("Expenses")) {
                        ForEach(expenses.sorted { $0.1 > $1.1 }, id: \.key) { key, value in
                            HStack {
                                // Parse icon and name if present
                                let parts = key.split(separator: " ", maxSplits: 1)
                                if parts.count == 2 {
                                    Image(systemName: String(parts[0]))
                                    Text(String(parts[1]))
                                } else {
                                    Text(key)
                                }
                                Spacer()
                                Text("\(value) kr")
                            }
                        }
                        .onDelete(perform: onDelete)
                    }
                }
                #if os(iOS)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Edit") {
                            showEditView = true
                        }
                    }
                }
                .listStyle(.insetGrouped)
                #endif
                .navigationTitle("iBudget")
                .sheet(isPresented: $showAddView) {
                    AddExpenseSheet(
                        inputKey: $inputKey,
                        inputValue: $inputValue,
                        showAddView: $showAddView,
                        onSave: onSave
                    )
                }
                .sheet(isPresented: $showEditView) {
                    EditIncomeSheet(
                        income: $income,
                        showEditView: $showEditView
                    )
                }

                // Floating Plus Button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            showAddView = true
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 60, height: 60)
                                .background(Color.blue)
                                .clipShape(Circle())
                                .shadow(radius: 8, y: 4)
                        }
                        .padding(.trailing, 30)
                    }
                }
            }
        }
    }
}

// MARK: - Budget Summary View
struct BudgetSummaryView: View {
    let income: Float
    let expenses: [String:Int]

    private var totalExpenses: Int {
        expenses.values.reduce(0, +)
    }

    private var savings: Int {
        Int(income) - totalExpenses
    }

    private var yearlySavings: Int {
        savings * 12
    }

    private var spendingPercentage: Double {
        guard income > 0 else { return 0 }
        return Double(totalExpenses) / Double(income)
    }

    private var progressBarColor: Color {
        switch spendingPercentage {
        case 0..<0.5:
            return .green
        case 0.5..<0.7:
            return .yellow
        case 0.7..<0.9:
            return .orange
        default:
            return .red
        }
    }

    private var progressBarText: String {
        switch spendingPercentage {
        case 0..<0.5:
            return "Great! You're saving a lot"
        case 0.5..<0.7:
            return "Good! You're still saving"
        case 0.7..<0.9:
            return "Warning! You're spending a lot"
        default:
            return "Danger! You're spending almost everything"
        }
    }

    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Monthly Income")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.leading, 25)
                    Label {
                        Text("\(Int(income)) kr")
                    } icon: {
                        Image(systemName: "arrow.down.circle.fill")
                            .foregroundColor(.green)
                    }
                    .labelStyle(IconOnlyLabelStyle())
                }
                Spacer()
                VStack(alignment: .leading, spacing: 2) {
                    Text("Monthly Saved")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.leading, 25)
                    Label {
                        Text("\(savings) kr")
                    } icon: {
                        Text("💰")
                    }
                    .labelStyle(IconOnlyLabelStyle())
                }
            }
            .font(.title3)
            .padding(.bottom, 4)

            GeometryReader { geometry in
                VStack(spacing: 4) {
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(height: 10)
                            .foregroundColor(.white)

                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: geometry.size.width * min(spendingPercentage, 1), height: 10)
                            .foregroundColor(progressBarColor)
                    }

                    Text(progressBarText)
                        .font(.caption)
                        .foregroundColor(progressBarColor)
                }
            }
            .frame(height: 30)
            .padding(.vertical, 5)

            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Monthly Spent")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.leading, 25)
                    Label {
                        Text("\(totalExpenses) kr")
                    } icon: {
                        Text("💸")
                    }
                    .labelStyle(IconOnlyLabelStyle())
                }
                Spacer()
                VStack(alignment: .leading, spacing: 2) {
                    Text("Yearly Saved")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.leading, 25)
                    Label {
                        Text("\(yearlySavings) kr")
                    } icon: {
                        Image(systemName: "chart.line.uptrend.xyaxis.circle.fill")
                            .foregroundColor(.purple)
                    }
                    .labelStyle(IconOnlyLabelStyle())
                }
            }
            .font(.title3)
            .padding(.top, 4)
        }
    }
}

struct IconOnlyLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 0) {
            configuration.icon
            configuration.title
        }
    }
}

// MARK: - Edit Income Sheet
struct EditIncomeSheet: View {
    @Binding var income: Float
    @Binding var showEditView: Bool

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Change your income here")
                    .font(.headline)
                    .padding()

                Text("\(Int(income)) kr")
                    .font(.title)
                    .padding()

                Slider(value: $income, in: 0...70000, step: 1000)
                    .padding(.horizontal)

                Spacer()
            }
            .padding(.top)
            .navigationTitle("Edit Income")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showEditView = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        UserDefaults.standard.set(income, forKey: "inkomst")
                        showEditView = false
                    }
                }
            }
        }
    }
}

// MARK: - Add Expense Sheet
struct AddExpenseSheet: View {
    @Binding var inputKey: String
    @Binding var inputValue: String
    @Binding var showAddView: Bool
    let onSave: () -> Void

    @State private var selectedCategory: ExpenseCategory? = nil
    @State private var sliderValue: Double = 0

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Picker("Category", selection: $selectedCategory) {
                    ForEach(predefinedCategories) { category in
                        HStack {
                            Image(systemName: category.icon)
                            Text(category.name)
                        }.tag(category as ExpenseCategory?)
                    }
                }
                #if os(iOS)
                .pickerStyle(.wheel)
                #endif
                .padding(.horizontal)

                if let selected = selectedCategory {
                    if selected.name == "Other" {
                        TextField("Enter expense category", text: $inputKey)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                        #if os(iOS)
                        TextField("Enter amount", text: $inputValue)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .padding(.horizontal)
                        #else
                        TextField("Enter amount", text: $inputValue)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                        #endif
                    } else {
                        Text("Amount: \(Int(sliderValue)) kr")
                            .font(.headline)
                        Slider(value: $sliderValue, in: 0...20000, step: 100)
                            .padding(.horizontal)
                            .onChange(of: sliderValue) { newValue in
                                inputValue = String(Int(newValue))
                            }
                    }
                }

                Spacer()
            }
            .padding(.top)
            .navigationTitle("Add Expense")
            #if os(iOS)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        inputKey = ""
                        inputValue = ""
                        showAddView = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let cat = selectedCategory {
                            if cat.name == "Other" {
                                // Prepend buying basket icon for custom category
                                inputKey = "cart.fill " + inputKey
                            } else {
                                inputKey = cat.icon + " " + cat.name
                            }
                        }
                        onSave()
                    }
                    .disabled(selectedCategory == nil || (selectedCategory?.name == "Other" ? (inputKey.isEmpty || inputValue.isEmpty) : inputValue.isEmpty))
                }
            }
            #endif
        }
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
