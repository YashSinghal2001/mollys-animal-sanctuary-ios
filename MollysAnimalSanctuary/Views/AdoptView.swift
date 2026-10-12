import SwiftUI

struct AdoptView: View {
    @EnvironmentObject private var store: SanctuaryStore

    var body: some View {
        let pets = store.filteredPets
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                ScreenHeader(title: "Adopt a Pet", subtitle: "Animals looking for a forever home in Kolkata")

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        FilterChip(title: "All animals", selected: store.speciesFilter == nil) {
                            store.speciesFilter = nil
                        }
                        ForEach(Species.allCases) { species in
                            FilterChip(title: "\(species.emoji) \(species.label)", selected: store.speciesFilter == species) {
                                store.speciesFilter = store.speciesFilter == species ? nil : species
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 2)
                }

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        FilterChip(title: "All areas", selected: store.areaFilter == nil) {
                            store.areaFilter = nil
                        }
                        ForEach(KolkataAreas.all, id: \.self) { area in
                            FilterChip(title: area, selected: store.areaFilter == area) {
                                store.areaFilter = store.areaFilter == area ? nil : area
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 2)
                }

                if pets.isEmpty {
                    Text("No pets match these filters yet.\nTry another area or animal.")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                        .padding(32)
                } else {
                    Text("\(pets.count) \(pets.count == 1 ? "pet" : "pets") available")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 16)
                        .padding(.top, 6)
                    LazyVStack(spacing: 12) {
                        ForEach(pets) { pet in
                            NavigationLink(value: PetRoute(id: pet.id)) {
                                PetCard(pet: pet)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                }
            }
        }
        .background(Color.appBackground)
        .toolbar(.hidden, for: .navigationBar)
    }
}
