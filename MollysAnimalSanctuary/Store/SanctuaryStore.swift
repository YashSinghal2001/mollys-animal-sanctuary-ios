import SwiftUI
import UIKit

enum AppTab: Hashable {
    case home, adopt, rehome, profile
}

/// Navigation value for opening a pet's detail screen.
struct PetRoute: Hashable {
    let id: String
}

/// Stores everything on the device (no login, no server): the user's profile, pets they
/// listed for rehoming, and the pets they asked to adopt.
final class SanctuaryStore: ObservableObject {
    @Published private(set) var myPets: [Pet]
    @Published private(set) var profile: Profile
    @Published private(set) var adoptionRequests: Set<String>

    @Published var selectedTab: AppTab = .home
    @Published var areaFilter: String?
    @Published var speciesFilter: Species?

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        myPets = Self.decode([Pet].self, from: defaults.data(forKey: Keys.pets)) ?? []
        profile = Self.decode(Profile.self, from: defaults.data(forKey: Keys.profile)) ?? Profile()
        adoptionRequests = Set(defaults.stringArray(forKey: Keys.requests) ?? [])
    }

    /// Every animal available for adoption: newly rehomed pets first, then the sanctuary's.
    var allPets: [Pet] { myPets + SamplePets.all }

    var filteredPets: [Pet] {
        allPets.filter { pet in
            (areaFilter == nil || pet.area == areaFilter) && (speciesFilter == nil || pet.species == speciesFilter)
        }
    }

    func pet(id: String) -> Pet? {
        allPets.first { $0.id == id }
    }

    @discardableResult
    func addPet(_ pet: Pet, photoData: Data?) -> Pet {
        var saved = pet
        saved.id = "pet-" + UUID().uuidString
        saved.listedByMe = true
        saved.createdAt = Date()
        if let photoData {
            saved.imageFileName = savePhoto(photoData, id: saved.id)
        }
        myPets.insert(saved, at: 0)
        persistPets()
        return saved
    }

    func removePet(id: String) {
        if let fileName = myPets.first(where: { $0.id == id })?.imageFileName {
            try? FileManager.default.removeItem(at: Self.photoURL(for: fileName))
        }
        myPets.removeAll { $0.id == id }
        persistPets()
    }

    func saveProfile(_ profile: Profile) {
        self.profile = profile
        defaults.set(try? JSONEncoder().encode(profile), forKey: Keys.profile)
    }

    func requestAdoption(petId: String) {
        adoptionRequests.insert(petId)
        defaults.set(Array(adoptionRequests), forKey: Keys.requests)
    }

    static func photoURL(for fileName: String) -> URL {
        photosDirectory.appendingPathComponent(fileName)
    }

    // MARK: - Private

    private static var photosDirectory: URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documents.appendingPathComponent("pets", isDirectory: true)
    }

    private func savePhoto(_ data: Data, id: String) -> String? {
        let jpeg = UIImage(data: data)?.jpegData(compressionQuality: 0.8) ?? data
        let fileName = "\(id).jpg"
        do {
            try FileManager.default.createDirectory(at: Self.photosDirectory, withIntermediateDirectories: true)
            try jpeg.write(to: Self.photoURL(for: fileName), options: .atomic)
            return fileName
        } catch {
            return nil
        }
    }

    private func persistPets() {
        defaults.set(try? JSONEncoder().encode(myPets), forKey: Keys.pets)
    }

    private static func decode<T: Decodable>(_ type: T.Type, from data: Data?) -> T? {
        guard let data else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }

    private enum Keys {
        static let pets = "my_pets"
        static let profile = "profile"
        static let requests = "adoption_requests"
    }
}
