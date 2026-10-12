import SwiftUI

@main
struct MollysAnimalSanctuaryApp: App {
    @StateObject private var store = SanctuaryStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .tint(.brandOrange)
        }
    }
}
