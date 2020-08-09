//
//  AccountAdd.swift
//  finance-forecast
//
//  Created by Jamie Willis on 09/08/2020.
//  Copyright © 2020 Jamie Willis. All rights reserved.
//

import SwiftUI

struct AccountAdd: View {
    
    @State var name = "New Account"
    
    let onComplete: (String) -> Void
    let onCancel: () -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Name")) {
                    TextField("Name", text: $name)
                }
            }
            .navigationBarTitle(Text("Add Account"), displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    self.onCancel()
                }) {
                    Text("Cancel")
                },
                trailing: Button(action: {
                    self.onComplete(self.name)
                }) {
                    Text("Create")
                }
            )
        }
    }
}

//struct AccountAdd_Previews: PreviewProvider {
//    static var previews: some View {
//        AccountAdd()
//    }
//}
