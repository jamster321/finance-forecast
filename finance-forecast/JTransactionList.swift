import SwiftUI

struct JTransactionList: View {
    @State private var isShowingDetailView = false
    @State private var editMode = EditMode.inactive
    
    var body: some View {
        VStack {
            NavigationLink(destination: newTransactionForm, isActive: $isShowingDetailView) {
                EmptyView()
            }
            List {
                ForEach(transactionData, id: \.self) { transaction in
                    JTransactionRow(transaction: transaction)
                }
                .onDelete(perform: self.delete)
            }
        }
        .navigationBarTitle(Text("Transactions"), displayMode: .inline)
        .navigationBarItems(trailing: addButton)
        .environment(\.editMode, $editMode)
    }
    
    private func delete(at indexSet: IndexSet) {
        transactionData.remove(atOffsets: indexSet)
    }
    
    private var addButton: some View {
        return AnyView(Button(action: self.showForm) {
            Image(systemName: "plus")
        }
        .padding([.leading, .top, .bottom])
        )
    }
    
    @State var description: String = ""
    @State var amount: String = ""
    @State var date: Date = Date.init()
    @State var monthly: Bool = false
    @State var completed: Bool = false
    
    var newTransactionForm: some View {
        Form {
            TextField("Description", text: self.$description)
            TextField("Amount", text: self.$amount).keyboardType(.decimalPad)
            DatePicker("Date", selection: self.$date, displayedComponents: .date)
            Toggle("Monthly", isOn: self.$monthly)
            Button(action: {
                self.addTransactionSubmit()
            }) {
                Text("Create")
            }
        }
        .navigationBarTitle(Text("New Transaction"), displayMode: .inline)
    }
    
    private func addTransactionSubmit() {
        let tx = JTransaction(
            id: 10,
            description: self.description,
            date: self.date,
            amount: (self.amount as NSString).floatValue,
            complete: false,
            monthly: self.monthly
        )
        transactionData.append(tx)
        self.isShowingDetailView = false
    }
    
    private func showForm() {
        self.isShowingDetailView = true
    }
}

struct JTransactionList_Previews: PreviewProvider {
    static var previews: some View {
        JTransactionList()
    }
}
