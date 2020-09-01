import SwiftUI

struct Forecast: Hashable, Identifiable {
    var id: Int
    var month: Int
    var year: Int
    var transactions: [Transaction]
    var endBalance: Double = 0
    
    let monthFormatter = DateFormatter()
    
    func transactionTotal() -> Double {
        var total: Double = 0
        for tx in self.transactions {
            total += tx.amount
        }
        return total
    }
    
    func date() -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = self.year
        dateComponents.month = self.month
        return Calendar.current.date(from: dateComponents)!
    }
    
    func monthString() -> String {
        monthFormatter.dateFormat = "MMMM"
        return monthFormatter.string(from: self.date())
    }
}
