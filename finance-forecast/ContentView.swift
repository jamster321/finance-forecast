//
//  ContentView.swift
//  finance-forecast
//
//  Created by Jamie Willis on 26/07/2020.
//  Copyright © 2020 Jamie Willis. All rights reserved.
//

import SwiftUI

let currencyFormatter = NumberFormatter()

var monthlyForecasts = [Forecast]()
struct ContentView: View {
    @EnvironmentObject private var userData: UserData
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(
      entity: Account.entity(),
      sortDescriptors: [
        NSSortDescriptor(keyPath: \Account.name, ascending: true)
      ]
    ) var accounts: FetchedResults<Account>
    
    @State private var selection = 0
    
    var totalBalance: Float {
//        var t: Float = 0
//        for account in accounts {
//            t += account.balance*(account.credit ? -1 : 1)
//        }
        return 0
    }
    
    init() {
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.currencyCode = "GBP"

        monthlyForecasts.removeAll()

        let currentDate = Date.init()
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        var forecastBalance = totalBalance

        for i in 0...3 {
            dateComponents.month = i
            let forecastDate = calendar.date(byAdding: dateComponents, to: currentDate)!
            let forecastMonth = calendar.component(.month, from: forecastDate)
            let forecastYear = calendar.component(.year, from: forecastDate)

            var forecast = Forecast(id: i, month: forecastMonth, year: forecastYear, transactions: [JTransaction]())

            for transaction in transactionData {
                let txMonth = calendar.component(.month, from: transaction.date)
                let txYear  = calendar.component(.year, from: transaction.date)

                if txMonth == forecastMonth && txYear == forecastYear {
                    forecast.transactions.append(transaction)
                }
            }

            forecastBalance = forecastBalance - forecast.transactionTotal()
            forecast.endBalance = forecastBalance

            monthlyForecasts.append(forecast)
        }
    }
    
    var body: some View {
        TabView(selection: $selection){
            AccountList()
                .tabItem {
                    Text("Accounts")
                    Image(systemName: "creditcard")
            }
            .tag(0)
            ForecastView(totalBalance: totalBalance)
                .tabItem {
                    Text("Forecast")
                    Image(systemName: "calendar")
            }
            .tag(1)
        }.environmentObject(userData)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let userData = UserData()
        return ContentView()
        .environmentObject(userData)
    }
}
