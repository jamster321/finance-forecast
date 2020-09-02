//
//  ContentView.swift
//  finance-forecast
//
//  Created by Jamie Willis on 26/07/2020.
//  Copyright © 2020 Jamie Willis. All rights reserved.
//

import SwiftUI

let currencyFormatter = NumberFormatter()


struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(
      entity: Account.entity(),
      sortDescriptors: [
        NSSortDescriptor(keyPath: \Account.name, ascending: true)
      ]
    ) var accounts: FetchedResults<Account>
    
    @FetchRequest(
        entity: Transaction.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Transaction.date, ascending: true)
        ]
    ) var transactions: FetchedResults<Transaction>
    
    @State private var selection = 0
    
    init() {
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.currencyCode = "GBP"
    }
    
    var totalBalance: Double {
        var t: Double = 0
        for account in accounts {
            t += account.balance*(account.credit ? -1 : 1)
        }
        return t
    }
    
    var body: some View {
        TabView(selection: $selection){
            AccountList()
                .tabItem {
                    Text("Accounts")
                    Image(systemName: "creditcard")
                }
                .tag(0)
            ForecastList(balance: self.totalBalance)
                .tabItem {
                    Text("Forecast")
                    Image(systemName: "calendar")
                }
                .tag(1)
            SavingsList()
                .tabItem {
                    Text("Savings")
                    Image(systemName: "briefcase")
                }
                .tag(2)
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        let userData = UserData()
//        return ContentView()
//        .environmentObject(userData)
//    }
//}
