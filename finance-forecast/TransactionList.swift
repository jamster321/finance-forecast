import SwiftUI

struct TransactionList: View {
    @Environment(\.managedObjectContext) var moc

    @State var isPresented = false
    @State private var isShowingDetailView = false
    @State private var editMode = EditMode.inactive
    
    var forecast: Forecast
    
    init(forecast: Forecast) {
        self.forecast = forecast
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(forecast.transactions, id: \.self) { transaction in
                    TransactionRow(transaction: transaction)
                }
                .onDelete(perform: deleteTransaction)
            }
            .sheet(isPresented: $isPresented) {
                TransactionAdd(
                    onComplete: self.addTransaction,
                    onCancel: self.cancelAddTransaction
                )
            }
        }
        .navigationBarTitle(Text("Transactions"), displayMode: .inline)
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
