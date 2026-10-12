import Foundation

enum Species: String, Codable, CaseIterable, Identifiable {
    case dog, cat, rabbit, bird, other

    var id: String { rawValue }

    var label: String {
        switch self {
        case .dog: return "Dog"
        case .cat: return "Cat"
        case .rabbit: return "Rabbit"
        case .bird: return "Bird"
        case .other: return "Other"
        }
    }

    var emoji: String {
        switch self {
        case .dog: return "🐶"
        case .cat: return "🐱"
        case .rabbit: return "🐰"
        case .bird: return "🐦"
        case .other: return "🐾"
        }
    }
}

enum Gender: String, Codable, CaseIterable, Identifiable {
    case male, female

    var id: String { rawValue }
    var label: String { self == .male ? "Male" : "Female" }
}

struct Pet: Codable, Identifiable, Hashable {
    var id: String
    var name: String
    var species: Species
    var breed: String
    var age: String
    var gender: Gender
    var area: String
    var description: String
    var vaccinated: Bool
    var sterilized: Bool
    var ownerName: String
    var ownerPhone: String
    /// File name of a photo stored in the app's Documents/pets folder, or nil for sample pets.
    var imageFileName: String? = nil
    /// True for pets this user put up for rehoming from this device.
    var listedByMe: Bool = false
    var createdAt: Date = Date()
}

struct Profile: Codable, Equatable {
    var name: String = ""
    var phone: String = ""
    var email: String = ""
    var area: String = ""

    var isComplete: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty && !phone.isEmpty
    }
}

enum KolkataAreas {
    static let all = [
        "Salt Lake",
        "New Town",
        "Park Street",
        "Ballygunge",
        "Gariahat",
        "Behala",
        "Tollygunge",
        "Jadavpur",
        "Garia",
        "Dum Dum",
        "Howrah",
        "Esplanade",
    ]
}
