import SwiftUI

struct ForecastRow: View {
    let forecast: Forecast
    
    init(forecast: Forecast) {
        self.forecast = forecast
    }
    
    var body: some View {
        VStack{
            HStack(alignment: .center) {
                Text("End of \(self.forecast.monthString())")
                Spacer()
                VStack(alignment: .trailing){
                    Text(self.monthlyTotal)
                        .font(.system(size: 14))
                        .fontWeight(.light)
                        .foregroundColor(self.totalColour)
                    Text(currencyFormatter.string(from: (self.forecast.endBalance as NSNumber))!)
                        .fontWeight(.medium)
                }
            }
        }
        .contentShape(Rectangle())
    }
    
    var totalColour: Color {
        var c = Color(UIColor.green)
        if (self.forecast.transactionTotal() < 0) {
            c = Color(UIColor.red)
        }
        return c
    }
    
    var monthlyTotal: String {
        var t = currencyFormatter.string(from: (self.forecast.transactionTotal()) as NSNumber)!
        if (self.forecast.transactionTotal() >= 0) {
            t = "+" + t
        }
        return t
    }
}


//struct ForecastRow_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            ForecastRow(forecast: forecast, change: 100.20)
//        }
//        .previewLayout(.fixed(width: 300, height: 70))
//    }
//}
