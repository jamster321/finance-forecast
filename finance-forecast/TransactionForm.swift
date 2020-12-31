import SwiftUI
import CoreData

struct TransactionForm: View {
    @Environment(\.presentationMode) var presentationMode
    
    var moc: NSManagedObjectContext
    
    var forecast: Forecast
    
    var transaction: Transaction?
    
    @State var name: String = ""
    @State var amount: Double = 0
    @State var date: Date = Date.init()
    @State var monthly: Bool = false
    @State var complete: Bool = false
    
    var title: String {
        transaction == nil ? "Create Transaction" : "Edit Transaction"
    }
    
    private var currencyFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.usesGroupingSeparator = true
        f.currencyCode = "GBP"
        f.isLenient = true
        f.numberStyle = .currency
        return f
    }()
    
    init(forecast: Forecast, transaction: Transaction?, moc: NSManagedObjectContext) {
        self.moc = moc
        self.forecast = forecast
        
        let f = NumberFormatter()
        f.currencyCode = "GBP"
        f.isLenient = true
        f.numberStyle = .currency
        
        if (transaction != nil) {
            let tx: Transaction = transaction!
            self.transaction = tx
            _name = State(initialValue: tx.name)
            _amount = State(initialValue: tx.amount)
            _date = State(initialValue: tx.date)
            _monthly = State(initialValue: tx.monthly)
            _complete = State(initialValue: tx.complete)
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    TextField("Name", text: self.$name)
                    TextField("Amount", value: self.$amount, formatter: currencyFormatter)
                }
                Button(action: self.addMonthlyTransaction) {
                    Text("Add Monthly Transactions")
                }
            }
            .navigationBarTitle(Text(title), displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: self.onCancel) {
                    VStack{
                        Spacer()
                        Text("Cancel")
                        Spacer()
                    }
                },
                trailing: Button(action: onComplete) {
                    VStack{
                        Spacer()
                        Text("Save")
                        Spacer()
                    }
                }
            )
        }
    }
    
    private func onComplete() {
        let tx: Transaction
        
        if let editedTransaction = self.transaction {
            tx = editedTransaction
        } else {
            tx = Transaction(context: self.moc)
        }

        tx.name = self.name
        tx.date = forecast.date()
        tx.amount = self.amount
        tx.complete = false
        tx.monthly = false
        
        do {
            try moc.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }

        self.presentationMode.wrappedValue.dismiss()
    }
    
    private func onCancel() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    private func addMonthlyTransaction() {
        newTransaction(name: "Example monthly transaction 1", amount: -100.00)
        newTransaction(name: "Example monthly transaction 2", amount: -70.00)

        do {
            try moc.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
        
        self.presentationMode.wrappedValue.dismiss()
    }
    
    private func newTransaction(name: String, amount: Double) {
        let tx = Transaction(context: self.moc)
        tx.name = name
        tx.amount = amount
        tx.date = forecast.date()
    }
}
