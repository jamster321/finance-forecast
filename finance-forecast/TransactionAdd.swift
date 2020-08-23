import SwiftUI

struct TransactionAdd: View {
    @State var name: String = ""
    @State var amount: String = ""
    @State var date: Date = Date.init()
    @State var monthly: Bool = false
    @State var completed: Bool = false
    
    let onComplete: (String, Date, Float) -> Void
    let onCancel: () -> Void
    
    var body: some View {
        NavigationView {
            Form {
                 TextField("Name", text: self.$name)
                 DatePicker("Date", selection: self.$date, displayedComponents: .date)
                 TextField("Amount", text: self.$amount).keyboardType(.decimalPad)
                 Toggle("Monthly", isOn: self.$monthly)
            }
            .navigationBarTitle(Text("New Transaction"), displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    self.onCancel()
                }) {
                    Text("Cancel")
                },
                trailing: Button(action: {
                    self.onComplete(self.name, self.date, (self.amount as NSString).floatValue)
                }) {
                    Text("Create")
                }
            )
        }
    }
}
