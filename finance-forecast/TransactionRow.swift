import SwiftUI

struct TransactionRow: View {
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var transaction: Transaction
    
    typealias MethodHandler2 = ()  -> Void
    var onEdit: MethodHandler2
    
    let dateFormatter = DateFormatter()
    
    init(transaction: Transaction, onEdit: @escaping MethodHandler2) {
        dateFormatter.dateFormat = "dd"
        self.transaction = transaction
        self.onEdit = onEdit
    }
    
    @State var isChecked:Bool = false
    func toggle(){
        isChecked = !isChecked
    }
    
    var body: some View {
        VStack{
            Button(action: onEdit){
                HStack(alignment: .center) {
                    Button(action: {
                        self.transaction.complete.toggle()
                        self.saveContext()
                    }){
                        VStack {
                            Spacer()
                            Image(systemName: transaction.complete ? "checkmark.square.fill": "square")
                            Spacer()
                        }
                    }
                    Text(transaction.name!)
                    Spacer()
                    Text(currencyFormatter.string(from: transaction.amount as NSNumber)!)

                }
            }
        }
    }
    
    func saveContext() {
        do {
            try moc.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
}

//struct TransactionRow_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            TransactionRow(transaction: transactionData[0])
//            TransactionRow(transaction: transactionData[1])
//        }
//        .previewLayout(.fixed(width: 300, height: 70))
//    }
//}
