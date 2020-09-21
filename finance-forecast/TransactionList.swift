import SwiftUI

struct TransactionList: View {
    @Environment(\.managedObjectContext) var moc

    @State var isPresented = false
    @State var editedTransaction: Transaction?
    @State private var editMode = EditMode.inactive
    @State var hideComplete = true
    
    var forecast: Forecast
    
    init(forecast: Forecast) {
        self.forecast = forecast
    }

    func onSave() {
        do {
            try moc.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(forecast.transactions, id: \.self) { transaction in
                    if (!self.hideComplete || !transaction.complete) {
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
        offsets.forEach { index in
            let transation = forecast.transactions[index]
            self.moc.delete(transation)
        }
        onSave()
    }
}

//struct TransactionList_Previews: PreviewProvider {
//    static var previews: some View {
//        TransactionList()
//    }
//}
