import SwiftUI

struct ForecastView: View {
    @State private var isShowingTransactionView = false
    @State var forecastBalance: Float = 0
    
    init(totalBalance: Float) {
        self.forecastBalance = totalBalance
    }
    
    func tapped() {
        self.isShowingTransactionView = true
    }

    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: JTransactionList(), isActive: $isShowingTransactionView) {
                    EmptyView()
                }
                List {
                    ForEach(monthlyForecasts, id: \.self) { forecast in
                        ForecastRow(date: forecast.date(), balance: forecast.endBalance!, change: forecast.transactionTotal())
                        .onTapGesture {
                            self.tapped()
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Forecast"))
        }
    }
}

struct ForecastView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastView(totalBalance: 200)
    }
}
