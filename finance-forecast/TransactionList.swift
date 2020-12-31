import SwiftUI

struct TransactionList: View {
    @Environment(\.managedObjectContext) var moc
    
    var fetchRequest: FetchRequest<Transaction>
    var transactions: FetchedResults<Transaction> { fetchRequest.wrappedValue }

    @State var isPresented = false
    @State var editedTransaction: Transaction?
    @State private var editMode = EditMode.inactive
    @State var hideComplete = true
    
    var forecast: Forecast
    
    init(forecast: Forecast) {
        fetchRequest = FetchRequest<Transaction>(entity: Transaction.entity(), sortDescriptors: [])
        self.forecast = forecast
    }
    
    func showCompleteTransaction(transaction: Transaction) -> Bool {
        return !self.hideComplete || !transaction.complete
    }
    
    func transactionMonth(transaction: Transaction) -> Bool {
        return transaction.date.get(.month) == forecast.month && transaction.date.get(.year) == forecast.year
    }
    
    var body: some View {
        ZStack {
            VStack {
                List {
                    ForEach(transactions, id: \.self) { transaction in
                        if (showCompleteTransaction(transaction: transaction) && transactionMonth(transaction: transaction)) {
                            TransactionRow(
                                transaction: transaction,
                                onEdit: {
                                    self.editedTransaction = transaction
                                    self.isPresented = true
                                }
                            )
                        }
                    }
                    .onDelete(perform: deleteTransaction)
                }
                .listStyle(PlainListStyle())
                .sheet(isPresented: $isPresented, onDismiss: {
                    self.editedTransaction = nil
                }) {
                    TransactionForm(forecast: self.forecast, transaction: self.editedTransaction, moc: self.moc)
                }
            }
            
            // This is a bit of a hack.
            // self.editedTransaction doesn't immediately change when the TransactionRow onEdit func sets it,
            // because self.editedTransaction isn't initially used anywhere in the UI.
            // It is used by TransactionForm, however TransactionForm hasn't been rendered by the UI until it has been
            // displayed at least once, and so it doesn't start working until the second time the sheet is displayed.
            // To get around this I've added this Text view (in a ZStack, so it's not visible), which uses self.editedTransaction.
            // The answer may be to add binding to the TransactionForm transaction or to initialise TransactionForm.
            Text(self.editedTransaction != nil ? "" : "").hidden()
        }
        .navigationBarTitle(Text(self.forecast.monthString()), displayMode: .inline)
        .navigationBarItems(trailing:
            HStack {
                Button(action: {
                    self.hideComplete.toggle()
                }) {
                    Spacer()
                    Image(systemName: self.hideComplete ? "eye.fill" : "eye.slash.fill")
                    Spacer()
                }
                .padding([.leading, .top, .bottom])
                Button(action: {
                    self.editedTransaction = nil
                    self.isPresented = true
                }) {
                    VStack {
                        Spacer()
                        Text("Add")
                        Spacer()
                    }
                }
                .padding([.leading, .top, .bottom])
            }
        )
        .environment(\.editMode, $editMode)
    }
    
    func deleteTransaction(at offsets: IndexSet) {
        for index in offsets {
            let transation = self.transactions[index]
            self.moc.delete(transation)
        }
        
        // Saving here is disabled because it causes a "Simultaneous accesses" threading error
        // We're save when the user closes the app, which is a workaround.
        // If they force close the app or it crashes they'll lose their changes
//        do {
//            try self.moc.save()
//        } catch {
//            print("Error saving managed object context: \(error)")
//        }
    }
}
