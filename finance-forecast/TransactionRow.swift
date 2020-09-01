import SwiftUI

struct TransactionRow: View {
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var transaction: Transaction
    
    var onEdit: () -> Void
    
    let generator = UINotificationFeedbackGenerator()
    
    init(transaction: Transaction, onEdit: @escaping ()  -> Void) {
        self.transaction = transaction
        self.onEdit = onEdit
    }
    
    var body: some View {
        VStack{
            Button(action: onEdit) {
                HStack(alignment: .center) {
                    Button(action: {
                        self.transaction.complete.toggle()
                        self.simpleSuccess()
                        try? self.moc.save()
                    }){
                        VStack {
                            Spacer()
                            Image(systemName: self.transaction.complete ? "checkmark.square.fill": "square")
                            Spacer()
                        }
                    }
                    Text(transaction.name)
                    Spacer()
                    Text(currencyFormatter.string(from: transaction.amount as NSNumber)!)
                }
            }
        }
    }
    
    func simpleSuccess() {
        generator.notificationOccurred(.success)
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
