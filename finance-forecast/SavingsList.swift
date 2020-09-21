import SwiftUI
import Introspect

struct SavingsList: View {
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(
        entity: Account.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Account.name, ascending: true)
        ],
        predicate: NSPredicate(format: "type == %@", "savings")
    ) var accounts: FetchedResults<Account>
    
    @State var isPresented = false
    
    var totalBalance: Double {
        var t: Double = 0
        for account in accounts {
            t += account.balance*(account.credit ? -1 : 1)
        }
        return t
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    Text("Balance")
                        .fontWeight(.medium)
                    Spacer()
                    Text("\( currencyFormatter.string(from: self.totalBalance as NSNumber)!)")
                        .fontWeight(.medium)
                }.padding([.horizontal])
                List {
                    ForEach(accounts, id: \.name) { account in
                        AccountRow(account: account)
                            .environment(\.managedObjectContext, self.moc)
                    }
                    .onDelete(perform: deleteAccount)
                }
                .listStyle(PlainListStyle())
                .sheet(isPresented: $isPresented) {
                    AccountAdd(
                        onComplete: self.addAccount,
                        onCancel: self.cancelAddAccount
                    )
                }
            }
            .navigationBarTitle("Savings")
            .navigationBarItems(trailing:
                Button(action: {
                    self.isPresented.toggle()
                }) {
                    Text("Add")
                }
                .padding([.leading, .top, .bottom])
            )
        }
        
    }
    
    func addAccount(name: String) {
        let account = Account(context: self.moc)
        account.name = name
        account.balance = 0.0
        account.type = "savings"
        self.saveContext()
        self.isPresented = false
    }
    
    func cancelAddAccount() {
        self.isPresented = false
    }
    
    func deleteAccount(at offsets: IndexSet) {
        offsets.forEach { index in
            let account = self.accounts[index]
            self.moc.delete(account)
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

//struct AccountList_Previews: PreviewProvider {
//    static var previews: some View {
//        let userData = UserData()
//        return AccountList()
//        .environmentObject(userData)
//
//    }
//}
