import SwiftUI

struct ForecastList: View {
    @Environment(\.managedObjectContext) var moc
    
    @State private var selectedForecast: Forecast?
    @State private var linkIsActive = false
    
    var balance: Double = 0
    
    var fetchRequest: FetchRequest<Transaction>
    var transactions: FetchedResults<Transaction> { fetchRequest.wrappedValue }
    
    let calendar = Calendar.current
    
    init(balance: Double) {
        fetchRequest = FetchRequest<Transaction>(entity: Transaction.entity(), sortDescriptors: [])
        self.balance = balance
    }
    
    func transactionTotal() -> Double {
        var total: Double = 0
        for tx in self.transactions {
            total += tx.amount
        }
        return total
    }
    
    func saveContext() {
        do {
            try moc.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }

    var body: some View {
        var monthlyForecasts = [Forecast]()
        
        let currentDate = Date.init()
        var dateComponents = DateComponents()
    
        var forecastBalance = self.balance

        for i in 0...3 {
            dateComponents.month = i
            let forecastDate = calendar.date(byAdding: dateComponents, to: currentDate)!
            let forecastMonth = calendar.component(.month, from: forecastDate)
            let forecastYear = calendar.component(.year, from: forecastDate)

            var forecast = Forecast(id: i, month: forecastMonth, year: forecastYear, transactions: [Transaction]())

            for transaction in transactions {
                let txMonth = calendar.component(.month, from: transaction.date)
                let txYear  = calendar.component(.year, from: transaction.date)

                if txMonth == forecast.month && txYear == forecast.year {
                    forecast.transactions.append(transaction)
                }
            }
            
            forecastBalance = forecastBalance + forecast.transactionTotal()
            forecast.endBalance = forecastBalance
            
            monthlyForecasts.append(forecast)
        }
        
        return NavigationView {
            ZStack {
                NavigationLink(
                    destination: linkDestination(selectedForecast: selectedForecast),
                    isActive: self.$linkIsActive) {
                        EmptyView()
                    }
                List(monthlyForecasts) { forecast in
                    Button(action: {
                        self.selectedForecast = forecast
                        self.linkIsActive = true
                    }) {
                        NavigationLink(destination: EmptyView()) {
                            ForecastRow(forecast: forecast)
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Forecast"))
        }
    }
    
    struct linkDestination: View {
        let selectedForecast: Forecast?
        var body: some View {
            return Group {
                if selectedForecast != nil {
                    TransactionList(forecast: selectedForecast!)
                } else {
                    EmptyView()
                }
            }
        }
    }
}

//struct ForecastList_Previews: PreviewProvider {
//    static var previews: some View {
//        ForecastList()
//    }
//}
