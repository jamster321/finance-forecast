import SwiftUI

struct Forecast: Hashable, Codable, Identifiable {
    var id: Int
    var month: Int
    var year: Int
    var transactions: [JTransaction]
    var endBalance: Float?
    
    func transactionTotal() -> Float {
        var total: Float = 0
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
}
