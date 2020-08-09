import SwiftUI

struct JTransaction: Hashable, Codable, Identifiable {
    var id: Int
    var description: String
    var date: Date
    var amount: Float
    var complete: Bool
    var monthly: Bool
}
