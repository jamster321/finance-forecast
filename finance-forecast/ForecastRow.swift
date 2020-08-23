import SwiftUI

struct ForecastRow: View {
    let date: Date
    let balance: Float
    let change: Float
    let monthFormatter = DateFormatter()
    
    init(date: Date, balance: Float, change: Float) {
        self.date = date
        self.balance = balance
        self.change = change * -1
        
        monthFormatter.dateFormat = "MMMM"
    }
    
    var body: some View {
        VStack{
            HStack(alignment: .center) {
                Text("End of \(monthFormatter.string(from: self.date))")
                Spacer()
                VStack(alignment: .trailing){
                    Text("\(currencyFormatter.string(from: self.change as NSNumber)!)")
                        .font(.system(size: 14))
                        .fontWeight(.light)
                        .foregroundColor(.green)
                    Text(currencyFormatter.string(from: self.balance as NSNumber)!)
                        .fontWeight(.medium)
                    }
            }
        }
        .contentShape(Rectangle())
    }
}


struct ForecastRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForecastRow(date: Date.init(), balance: 789.29, change: 100.20)
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
