import SwiftUI

struct TransactionRow: View {
    var transaction: Transaction
    let dateFormatter = DateFormatter()
    
    init(transaction: Transaction) {
        dateFormatter.dateFormat = "dd MMM"
        self.transaction = transaction
    }
    
    @State var isChecked:Bool = false
    func toggle(){isChecked = !isChecked}
    
    var body: some View {
        VStack{
            HStack(alignment: .top) {
                Text(dateFormatter.string(from: transaction.date!))
                Text(transaction.name!)
                Spacer()
                Text(currencyFormatter.string(from: (transaction.amount * -1) as NSNumber)!)
                Button(action: toggle){
                    HStack{
                        Image(systemName: isChecked ? "checkmark.square": "square")
                    }
                }
            }
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
