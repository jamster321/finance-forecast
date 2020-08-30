import SwiftUI

struct TransactionForm: View {
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var transaction: Transaction
    
    @State var name: String = ""
    @State var amount: String = ""
    @State var date: Date = Date.init()
    @State var monthly: Bool = false
    @State var complete: Bool = false
    
    let onComplete: (String, Date, Float) -> Void
    let onCancel: () -> Void
    
    private var currencyFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.usesGroupingSeparator = true
        f.currencyCode = "GBP"
        f.isLenient = true
        f.numberStyle = .currency
        return f
    }()
    
    init(
        onComplete: @escaping (String, Date, Float) -> Void,
        onCancel: @escaping () -> Void,
        transaction: Transaction
    ) {
        let f = NumberFormatter()
        f.usesGroupingSeparator = true
        f.currencyCode = "GBP"
        f.isLenient = true
        f.numberStyle = .currency
        
        self.onComplete = onComplete
        self.onCancel = onCancel
        self.transaction = transaction
        _name = State(initialValue: transaction.name!)
        _amount = State(initialValue: currencyFormatter.string(from: (transaction.amount as NSNumber))!)
        _date = State(initialValue: transaction.date!)
        _monthly = State(initialValue: transaction.monthly)
        _complete = State(initialValue: transaction.complete)
    }
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: self.$name)
                DatePicker("Date", selection: self.$date, displayedComponents: .date)
                TextField("Amount", text: self.$amount)
                Toggle("Monthly", isOn: self.$monthly)
            }
            .navigationBarTitle(Text("New Transaction"), displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    self.onCancel()
                }) {
                    Text("Cancel")
                },
                trailing: Button(action: {
                    
                    self.onComplete(self.name, self.date, (self.amount as NSString).floatValue)
                }) {
                    Text("Create")
                }
            )
        }
    }
}
