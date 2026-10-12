import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var store: SanctuaryStore

    var body: some View {
        let pets = store.allPets
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                hero

                VStack(alignment: .leading, spacing: 12) {
                    Text("What would you like to do?").font(.title2.bold())
                    HStack(spacing: 12) {
                        ChoiceCard(
                            icon: "pawprint.fill",
                            title: "Adopt a Pet",
                            message: "Browse dogs, cats and more waiting for a home near you.",
                            background: .primaryContainer,
                            foreground: .onPrimaryContainer
                        ) { store.selectedTab = .adopt }
                        ChoiceCard(
                            icon: "hand.raised.fill",
                            title: "Rehome a Pet",
                            message: "Can't keep your pet? Donate them to a caring new family.",
                            background: .secondaryContainer,
                            foreground: .onSecondaryContainer
                        ) { store.selectedTab = .rehome }
                    }
                }
                .padding(.horizontal, 16)

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Waiting for a home").font(.title2.bold())
                        Spacer()
                        Button("See all (\(pets.count))") { store.selectedTab = .adopt }
                    }
                    .padding(.horizontal, 16)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(pets.prefix(8)) { pet in
                                NavigationLink(value: PetRoute(id: pet.id)) {
                                    PetTile(pet: pet)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Browse by area in Kolkata")
                        .font(.title2.bold())
                        .padding(.horizontal, 16)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(KolkataAreas.all, id: \.self) { area in
                                let count = pets.filter { $0.area == area }.count
                                FilterChip(title: count > 0 ? "\(area) (\(count))" : area, selected: false) {
                                    store.areaFilter = area
                                    store.selectedTab = .adopt
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 2)
                    }
                }
            }
            .padding(.bottom, 24)
        }
        .background(Color.appBackground)
        .toolbar(.hidden, for: .navigationBar)
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("🐾").font(.largeTitle)
            Text(store.profile.name.isEmpty
                 ? "Welcome!"
                 : "Hi \(store.profile.name.split(separator: " ").first.map(String.init) ?? store.profile.name)!")
                .font(.headline)
                .foregroundStyle(.white.opacity(0.9))
            Text("Molly's Animal Sanctuary")
                .font(.title.bold())
                .foregroundStyle(.white)
            Text("Every pet deserves a loving home. Adopt a friend, or find a caring new family for yours, right here in Kolkata.")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.92))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(24)
        .background(
            LinearGradient(
                colors: [Color(UIColor(hex: 0xE8692C)), Color(UIColor(hex: 0xF2A65A))],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 28, style: .continuous)
        )
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
}

private struct ChoiceCard: View {
    let icon: String
    let title: String
    let message: String
    let background: Color
    let foreground: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                Image(systemName: icon).font(.system(size: 30))
                Text(title).font(.headline)
                Text(message).font(.caption).multilineTextAlignment(.leading)
                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, minHeight: 170, alignment: .topLeading)
            .padding(16)
            .foregroundStyle(foreground)
            .background(background, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}
