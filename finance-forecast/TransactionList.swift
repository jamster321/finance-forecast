import SwiftUI

struct TransactionList: View {
    @Environment(\.managedObjectContext) var moc

    @State var isPresented = false
    @State private var editMode = EditMode.inactive
    
    var forecast: Forecast
    
    init(forecast: Forecast) {
        self.forecast = forecast
    }
    
    @State var editedTransaction: Transaction?
    
    var transactionForm: some View {
        TransactionForm(
            onComplete: self.addTransaction,
            onCancel: self.cancelAddTransaction,
            transaction: self.editedTransaction!
        )
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(forecast.transactions, id: \.self) { transaction in
                    TransactionRow(
                        transaction: transaction,
                        onEdit: {
                            self.editedTransaction = transaction
                            self.isPresented = true
                        }
                    )
                }
                .onDelete(perform: deleteTransaction)
            }
            .sheet(isPresented: $isPresented) {
                self.transactionForm
            }
        }
        .navigationBarTitle(Text(self.forecast.monthString()), displayMode: .inline)
        .navigationBarItems(trailing:
            Button(action: {
                self.isPresented.toggle()
            }) {
                Text("Add")
            }
            .padding([.leading, .top, .bottom])
        )
        .environment(\.editMode, $editMode)
    }
    
    func addTransaction(name: String, date: Date, amount: Float) {
        let tx = Transaction(context: self.moc)

        tx.name = name
        tx.date = date
        tx.amount = amount

        self.saveContext()
        self.isPresented = false
    }
    
    func cancelAddTransaction() {
        self.isPresented = false
    }
    
    func deleteTransaction(at offsets: IndexSet) {
        offsets.forEach { index in
            let transation = forecast.transactions[index]
            self.moc.delete(transation)
        }
        saveContext()
    }
    
    func saveContext() {
        do {
            try moc.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
}

//struct TransactionList_Previews: PreviewProvider {
//    static var previews: some View {
//        TransactionList()
//    }
//}
