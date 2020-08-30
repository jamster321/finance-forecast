import SwiftUI

struct ForecastList: View {
    var forecastBalance: Float = 0
    
    var monthlyForecasts = [Forecast]()
    
    init(transactions: FetchedResults<Transaction>, balance: Float) {
        let currentDate = Date.init()
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        forecastBalance = balance

        monthlyForecasts.removeAll()

        for i in 0...3 {
            dateComponents.month = i
            let forecastDate = calendar.date(byAdding: dateComponents, to: currentDate)!
            let forecastMonth = calendar.component(.month, from: forecastDate)
            let forecastYear = calendar.component(.year, from: forecastDate)

            var forecast = Forecast(id: i, month: forecastMonth, year: forecastYear, transactions: [Transaction]())

            for transaction in transactions {
                let txMonth = calendar.component(.month, from: transaction.date!)
                let txYear  = calendar.component(.year, from: transaction.date!)

                if txMonth == forecastMonth && txYear == forecastYear {
                    forecast.transactions.append(transaction)
                }
            }

            forecastBalance = forecastBalance + forecast.transactionTotal()
            forecast.endBalance = forecastBalance

            monthlyForecasts.append(forecast)
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(monthlyForecasts, id: \.self) { forecast in
                    NavigationLink(destination: TransactionList(forecast: forecast)) {
                        ForecastRow(forecast: forecast)
                    }
                }
            }
            .navigationBarTitle(Text("Forecast"))
        }
    }
}

//struct ForecastList_Previews: PreviewProvider {
//    static var previews: some View {
//        ForecastList()
//    }
//}
