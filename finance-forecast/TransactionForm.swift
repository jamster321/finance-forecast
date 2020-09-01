import SwiftUI
import CoreData

struct TransactionForm: View {
    @Environment(\.presentationMode) var presentationMode
    
    var moc: NSManagedObjectContext
    
    var forecast: Forecast
    
    var transaction: Transaction?
    
    @State var name: String = ""
    @State var amount: String = ""
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
            _amount = State(initialValue: currencyFormatter.string(from: (tx.amount as NSNumber))!)
            _date = State(initialValue: tx.date)
            _monthly = State(initialValue: tx.monthly)
            _complete = State(initialValue: tx.complete)
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: self.$name)
                DatePicker("Date", selection: self.$date, displayedComponents: .date)
                TextField("Amount", value: self.$amount, formatter: currencyFormatter)
                Toggle("Monthly", isOn: self.$monthly)
                Toggle("Complete", isOn: self.$complete)
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
        tx.date = self.date
        tx.amount = (self.amount as NSString).doubleValue
        tx.complete = self.complete
        tx.monthly = self.monthly
        
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
}
