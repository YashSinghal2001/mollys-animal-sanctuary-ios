import SwiftUI

struct PetDetailView: View {
    let petId: String

    @EnvironmentObject private var store: SanctuaryStore
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL
    @State private var dialog: DetailDialog?

    private enum DetailDialog: Identifiable {
        case needProfile, confirmAdopt, sent, confirmRemove
        var id: Self { self }
    }

    var body: some View {
        Group {
            if let pet = store.pet(id: petId) {
                content(for: pet)
            } else {
                VStack(spacing: 12) {
                    Text("This pet is no longer listed.").font(.headline)
                    Button("Go back") { dismiss() }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .background(Color.appBackground)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }

    @ViewBuilder
    private func content(for pet: Pet) -> some View {
        let requested = store.adoptionRequests.contains(pet.id)
        let profile = store.profile

        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                PetImage(pet: pet, emojiSize: 120)
                    .frame(maxWidth: .infinity)
                    .frame(height: 300)
                    .clipped()

                VStack(alignment: .leading, spacing: 14) {
                    Text(pet.name).font(.largeTitle.bold())
                    AreaLabel(area: pet.area)

                    WrappingHStack {
                        InfoPill(text: "\(pet.species.emoji) \(pet.species.label)")
                        if !pet.breed.isEmpty { InfoPill(text: pet.breed) }
                        if !pet.age.isEmpty { InfoPill(text: pet.age) }
                        InfoPill(text: pet.gender.label)
                        InfoPill(text: pet.vaccinated ? "Vaccinated" : "Not vaccinated")
                        InfoPill(text: pet.sterilized ? "Sterilized" : "Not sterilized")
                    }

                    if !pet.description.isEmpty {
                        Text("About \(pet.name)").font(.headline)
                        Text(pet.description).font(.body)
                    }

                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Listed by").font(.caption).foregroundStyle(.secondary)
                            Text(pet.listedByMe ? "You" : pet.ownerName).font(.headline)
                            Text(pet.ownerPhone).font(.subheadline)
                        }
                        Spacer()
                        if !pet.listedByMe && !pet.ownerPhone.isEmpty {
                            Button {
                                if let url = URL(string: "tel:\(pet.ownerPhone)") { openURL(url) }
                            } label: {
                                Image(systemName: "phone.fill")
                                    .font(.title3)
                                    .frame(width: 48, height: 48)
                                    .background(Color.secondaryContainer, in: Circle())
                                    .foregroundStyle(Color.onSecondaryContainer)
                            }
                            .accessibilityLabel("Call \(pet.ownerName)")
                        }
                    }
                    .padding(16)
                    .background(Color.cardBackground, in: RoundedRectangle(cornerRadius: 16, style: .continuous))

                    Group {
                        if pet.listedByMe {
                            Button(role: .destructive) { dialog = .confirmRemove } label: {
                                Text("Remove my listing").frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.bordered)
                        } else if requested {
                            Button {} label: {
                                Label("Adoption request sent", systemImage: "checkmark.circle.fill")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.bordered)
                            .disabled(true)
                        } else {
                            Button {
                                dialog = profile.isComplete ? .confirmAdopt : .needProfile
                            } label: {
                                Text("I want to adopt \(pet.name)").frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                    .controlSize(.large)
                    .padding(.top, 4)
                }
                .padding(20)
            }
        }
        .navigationTitle(pet.name)
        .alert(
            alertTitle(for: pet),
            isPresented: Binding(get: { dialog != nil }, set: { if !$0 { dialog = nil } }),
            presenting: dialog
        ) { current in
            switch current {
            case .needProfile:
                Button("Go to profile") { store.selectedTab = .profile }
                Button("Cancel", role: .cancel) {}
            case .confirmAdopt:
                Button("Send request") {
                    store.requestAdoption(petId: pet.id)
                    // Show the thank-you alert once this one has finished dismissing.
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { dialog = .sent }
                }
                Button("Cancel", role: .cancel) {}
            case .sent:
                Button("OK", role: .cancel) {}
            case .confirmRemove:
                Button("Remove", role: .destructive) {
                    dismiss()
                    store.removePet(id: pet.id)
                }
                Button("Cancel", role: .cancel) {}
            }
        } message: { current in
            switch current {
            case .needProfile:
                Text("Add your name and mobile number so \(pet.ownerName) can contact you about \(pet.name).")
            case .confirmAdopt:
                Text("We'll share your details (\(profile.name), \(profile.phone)) with \(pet.ownerName). They'll get in touch to arrange a meet-up.")
            case .sent:
                Text("Thank you for choosing to adopt! You can also call \(pet.ownerName) directly at \(pet.ownerPhone).")
            case .confirmRemove:
                Text("\(pet.name) will no longer be shown to people looking to adopt.")
            }
        }
    }

    private func alertTitle(for pet: Pet) -> String {
        switch dialog {
        case .needProfile: return "Complete your profile"
        case .confirmAdopt: return "Adopt \(pet.name)?"
        case .sent: return "Request sent 🎉"
        case .confirmRemove: return "Remove \(pet.name)?"
        case nil: return ""
        }
    }
}
