import PhotosUI
import SwiftUI

struct RehomeView: View {
    var onListed: (String) -> Void

    @EnvironmentObject private var store: SanctuaryStore

    @State private var photoItem: PhotosPickerItem?
    @State private var photoData: Data?
    @State private var name = ""
    @State private var species: Species = .dog
    @State private var breed = ""
    @State private var age = ""
    @State private var gender: Gender = .male
    @State private var area = ""
    @State private var description = ""
    @State private var vaccinated = false
    @State private var sterilized = false
    @State private var ownerName = ""
    @State private var ownerPhone = ""
    @State private var showErrors = false

    private var nameError: Bool { name.trimmingCharacters(in: .whitespaces).isEmpty }
    private var areaError: Bool { area.isEmpty }
    private var ownerNameError: Bool { ownerName.trimmingCharacters(in: .whitespaces).isEmpty }
    private var phoneError: Bool { !Validation.isValidIndianMobile(ownerPhone) }

    var body: some View {
        Form {
            Section {
                ScreenHeader(
                    title: "Rehome a Pet",
                    subtitle: "Donate your pet to a loving new family. Add a photo and a few details and we'll show them to adopters across Kolkata."
                )
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
            }

            Section {
                PhotosPicker(selection: $photoItem, matching: .images) {
                    photoPreview
                }
                .buttonStyle(.plain)
                .listRowInsets(EdgeInsets())
            }

            Section("Pet details") {
                TextField("Pet's name *", text: $name)
                    .textInputAutocapitalization(.words)
                    .foregroundStyle(showErrors && nameError ? Color.red : Color.primary)
                if showErrors && nameError { errorText("Please enter your pet's name") }

                Picker("Animal", selection: $species) {
                    ForEach(Species.allCases) { Text("\($0.emoji) \($0.label)").tag($0) }
                }
                TextField("Breed (e.g. Indie, Labrador)", text: $breed)
                TextField("Age (e.g. 2 years)", text: $age)
                Picker("Gender", selection: $gender) {
                    ForEach(Gender.allCases) { Text($0.label).tag($0) }
                }
                .pickerStyle(.segmented)

                Picker("Area in Kolkata *", selection: $area) {
                    Text("Select area").tag("")
                    ForEach(KolkataAreas.all, id: \.self) { Text($0).tag($0) }
                }
                if showErrors && areaError { errorText("Please choose an area") }

                Toggle("Vaccinated", isOn: $vaccinated)
                Toggle("Sterilized / neutered", isOn: $sterilized)
                TextField(
                    "Tell adopters about your pet: temperament, habits, food, why you're rehoming…",
                    text: $description,
                    axis: .vertical
                )
                .lineLimit(3...6)
            }

            Section("Your contact details") {
                TextField("Your name *", text: $ownerName)
                    .textInputAutocapitalization(.words)
                if showErrors && ownerNameError { errorText("Please enter your name") }
                HStack {
                    Text("+91").foregroundStyle(.secondary)
                    TextField("Mobile number *", text: $ownerPhone)
                        .keyboardType(.phonePad)
                }
                if showErrors && phoneError { errorText("Enter a valid 10-digit mobile number") }
            }

            Section {
                Button(action: submit) {
                    Text("List my pet for adoption")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.appBackground)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear(perform: prefillFromProfile)
        .onChange(of: store.profile) { _ in prefillFromProfile() }
        .onChange(of: ownerPhone) { newValue in
            let digits = Validation.phoneDigits(newValue)
            if digits != newValue { ownerPhone = digits }
        }
        .onChange(of: photoItem) { item in
            Task {
                if let data = try? await item?.loadTransferable(type: Data.self) {
                    await MainActor.run { photoData = data }
                }
            }
        }
    }

    @ViewBuilder
    private var photoPreview: some View {
        if let photoData, let image = UIImage(data: photoData) {
            Color.clear
                .frame(height: 200)
                .overlay(Image(uiImage: image).resizable().scaledToFill())
                .clipped()
        } else {
            VStack(spacing: 6) {
                Image(systemName: "camera.fill").font(.system(size: 36))
                Text("Add your pet's photo").font(.headline)
                Text("Tap to choose from gallery").font(.caption).foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 200)
            .background(Color.cardBackground)
        }
    }

    private func errorText(_ text: String) -> some View {
        Text(text).font(.caption).foregroundStyle(.red)
    }

    /// Pre-fill contact details from the profile.
    private func prefillFromProfile() {
        let profile = store.profile
        if ownerName.isEmpty { ownerName = profile.name }
        if ownerPhone.isEmpty { ownerPhone = profile.phone }
        if area.isEmpty && !profile.area.isEmpty { area = profile.area }
    }

    private func submit() {
        showErrors = true
        guard !nameError, !areaError, !ownerNameError, !phoneError else { return }

        let pet = Pet(
            id: "",
            name: name.trimmingCharacters(in: .whitespaces),
            species: species,
            breed: breed.trimmingCharacters(in: .whitespaces),
            age: age.trimmingCharacters(in: .whitespaces),
            gender: gender,
            area: area,
            description: description.trimmingCharacters(in: .whitespacesAndNewlines),
            vaccinated: vaccinated,
            sterilized: sterilized,
            ownerName: ownerName.trimmingCharacters(in: .whitespaces),
            ownerPhone: String(ownerPhone.suffix(10))
        )
        let saved = store.addPet(pet, photoData: photoData)

        showErrors = false
        photoItem = nil
        photoData = nil
        name = ""
        breed = ""
        age = ""
        description = ""
        vaccinated = false
        sterilized = false
        onListed(saved.id)
    }
}
