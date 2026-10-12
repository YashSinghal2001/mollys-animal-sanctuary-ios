import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var store: SanctuaryStore

    @State private var name = ""
    @State private var phone = ""
    @State private var email = ""
    @State private var area = ""
    @State private var showErrors = false
    @State private var saved = false

    private var nameError: Bool { name.trimmingCharacters(in: .whitespaces).isEmpty }
    private var phoneError: Bool { !Validation.isValidIndianMobile(phone) }
    private var emailError: Bool { !Validation.isValidEmail(email) }

    var body: some View {
        let profile = store.profile
        let requestedPets = store.allPets.filter { store.adoptionRequests.contains($0.id) }

        Form {
            Section {
                ScreenHeader(
                    title: "My Profile",
                    subtitle: "No login needed. Your details stay on this phone and are shared only when you contact a pet owner."
                )
                HStack(spacing: 16) {
                    Text(profile.name.trimmingCharacters(in: .whitespaces).first.map { String($0).uppercased() } ?? "🐾")
                        .font(.title.bold())
                        .foregroundStyle(Color.onPrimaryContainer)
                        .frame(width: 64, height: 64)
                        .background(Color.primaryContainer, in: Circle())
                    VStack(alignment: .leading, spacing: 2) {
                        Text(profile.name.isEmpty ? "Guest" : profile.name).font(.title3.bold())
                        Text("\(store.myPets.count) listed · \(store.adoptionRequests.count) adoption requests")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 8)
            }
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets())

            Section("Your details") {
                TextField("Full name *", text: $name)
                    .textInputAutocapitalization(.words)
                if showErrors && nameError { errorText("Please enter your name") }

                HStack {
                    Text("+91").foregroundStyle(.secondary)
                    TextField("Mobile number *", text: $phone)
                        .keyboardType(.phonePad)
                }
                if showErrors && phoneError { errorText("Enter a valid 10-digit mobile number") }

                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                if showErrors && emailError { errorText("Enter a valid email address") }

                Picker("Your area in Kolkata", selection: $area) {
                    Text("Not set").tag("")
                    ForEach(KolkataAreas.all, id: \.self) { Text($0).tag($0) }
                }
            }

            Section {
                Button(action: save) {
                    Text(saved ? "Saved ✓" : "Save profile")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
            }

            if !store.myPets.isEmpty {
                Section("Pets I'm rehoming") {
                    ForEach(store.myPets) { pet in
                        petRow(pet)
                    }
                }
            }

            if !requestedPets.isEmpty {
                Section("My adoption requests") {
                    ForEach(requestedPets) { pet in
                        petRow(pet)
                    }
                }
            }

            Section {
                VStack(alignment: .leading, spacing: 4) {
                    Text("About Molly's Animal Sanctuary").font(.headline)
                    Text("We help animals in Kolkata find safe, loving homes. Visit mollysanimalsanctuary.org to learn more.")
                        .font(.subheadline)
                }
                .padding(.vertical, 4)
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.appBackground)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear { load(profile) }
        .onChange(of: store.profile) { load($0) }
        .onChange(of: phone) { newValue in
            let digits = Validation.phoneDigits(newValue)
            if digits != newValue { phone = digits }
        }
    }

    private func petRow(_ pet: Pet) -> some View {
        NavigationLink(value: PetRoute(id: pet.id)) {
            HStack(spacing: 12) {
                PetImage(pet: pet, emojiSize: 28)
                    .frame(width: 56, height: 56)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                VStack(alignment: .leading, spacing: 2) {
                    Text(pet.name).font(.headline)
                    AreaLabel(area: pet.area)
                }
            }
        }
    }

    private func errorText(_ text: String) -> some View {
        Text(text).font(.caption).foregroundStyle(.red)
    }

    private func load(_ profile: Profile) {
        name = profile.name
        phone = profile.phone
        email = profile.email
        area = profile.area
    }

    private func save() {
        showErrors = true
        guard !nameError, !phoneError, !emailError else { return }
        store.saveProfile(Profile(
            name: name.trimmingCharacters(in: .whitespaces),
            phone: phone,
            email: email.trimmingCharacters(in: .whitespaces),
            area: area
        ))
        showErrors = false
        saved = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { saved = false }
    }
}
