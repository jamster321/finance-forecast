//
//  AccountAdd.swift
//  finance-forecast
//
//  Created by Jamie Willis on 09/08/2020.
//  Copyright © 2020 Jamie Willis. All rights reserved.
//

import SwiftUI

struct AccountAdd: View {
    
    @State var name = ""
    
    let onComplete: (String) -> Void
    let onCancel: () -> Void
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
            }
            .navigationBarTitle(Text("Add Account"), displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    self.onCancel()
                }) {
                    Spacer()
                    Text("Cancel")
                    Spacer()
                },
                trailing: Button(action: {
                    self.onComplete(self.name)
                }) {
                    Spacer()
                    Text("Create")
                    Spacer()
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
