import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var store: SanctuaryStore

    var body: some View {
        TabView(selection: $store.selectedTab) {
            NavigationStack {
                HomeView().withPetDestination()
            }
            .tabItem { Label("Home", systemImage: "house.fill") }
            .tag(AppTab.home)

            NavigationStack {
                AdoptView().withPetDestination()
            }
            .tabItem { Label("Adopt", systemImage: "pawprint.fill") }
            .tag(AppTab.adopt)

            RehomeTab()
                .tabItem { Label("Rehome", systemImage: "hand.raised.fill") }
                .tag(AppTab.rehome)

            NavigationStack {
                ProfileView().withPetDestination()
            }
            .tabItem { Label("Profile", systemImage: "person.fill") }
            .tag(AppTab.profile)
        }
    }
}

/// The Rehome tab keeps its own navigation path so it can open the new listing after saving.
private struct RehomeTab: View {
    @State private var path: [PetRoute] = []

    var body: some View {
        NavigationStack(path: $path) {
            RehomeView(onListed: { path.append(PetRoute(id: $0)) })
                .withPetDestination()
        }
    }
}

extension View {
    func withPetDestination() -> some View {
        navigationDestination(for: PetRoute.self) { route in
            PetDetailView(petId: route.id)
        }
    }
}
