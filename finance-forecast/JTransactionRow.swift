import SwiftUI

struct JTransactionRow: View {
    var transaction: JTransaction
    let dateFormatter = DateFormatter()
    
    init(transaction: JTransaction) {
        dateFormatter.dateFormat = "dd MMM"
        self.transaction = transaction
    }
    
    @State var isChecked:Bool = false
    func toggle(){isChecked = !isChecked}
    
    var body: some View {
        VStack{
            HStack(alignment: .top) {
                Text(dateFormatter.string(from: transaction.date))
                Text(transaction.description)
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

struct JTransactionRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            JTransactionRow(transaction: transactionData[0])
            JTransactionRow(transaction: transactionData[1])
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
