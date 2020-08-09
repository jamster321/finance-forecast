import Combine
import SwiftUI

final class UserData: ObservableObject {
    @Published var accounts: [Account] = [Account]()
}
