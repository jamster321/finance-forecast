import SwiftUI

struct AccountRow: View {
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var account: Account
    
    init(account: Account) {
        self.account = account
    }
    
    private var currencyFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.usesGroupingSeparator = true
        f.currencyCode = "GBP"
        f.isLenient = true
        f.numberStyle = .currency
        return f
    }()
    
    var body: some View {
        HStack(alignment: .top) {
            Text(account.name)
            Spacer()
            TextField("Balance",
                      value: self.$account.balance,
                      formatter: currencyFormatter,
                      onCommit: saveContext
            ).foregroundColor(Color.blue).multilineTextAlignment(.trailing)
        }
        .contentShape(Rectangle())
    }
    
    func saveContext() {
        do {
            try moc.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
}

//struct AccountRow_Previews: PreviewProvider {
//    static var previews: some View {
//        let userData = UserData()
//        return AccountRow(account: userData.accounts[0])
//            .environmentObject(userData)
//            .previewLayout(.fixed(width: 300, height: 70))
//    }
//}
