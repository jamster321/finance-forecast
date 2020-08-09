import SwiftUI

struct AccountRow: View {
    @EnvironmentObject var userData: UserData
    var account: Account
    
    @State private var balance: Float = 0
    
    init(account: Account) {
        self.account = account
        self._balance = State(wrappedValue: account.balance)
    }
    
    var accountIndex: Int {
        userData.accounts.firstIndex(where: { $0.name == account.name })!
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
        VStack{
            HStack(alignment: .top) {
                account.name.map(Text.init)
                Spacer()
                TextField("Balance",
                           value: $balance,
                           formatter: currencyFormatter,
                           onCommit: {
                            self.account.balance = self.balance
                 }).foregroundColor(Color.blue).multilineTextAlignment(.trailing)
            }
        }
        .contentShape(Rectangle())
        .padding()
    }
}

struct AccountRow_Previews: PreviewProvider {
    static var previews: some View {
        let userData = UserData()
        return AccountRow(account: userData.accounts[0])
            .environmentObject(userData)
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
