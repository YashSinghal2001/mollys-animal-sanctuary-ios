import Foundation

/// Animals currently at the sanctuary, shown to everyone on first launch.
enum SamplePets {
    static let all: [Pet] = [
        Pet(
            id: "sample-molly", name: "Molly", species: .dog, breed: "Indie", age: "2 years",
            gender: .female, area: "Salt Lake",
            description: "Gentle, loves belly rubs and long walks. Great with kids and other dogs.",
            vaccinated: true, sterilized: true,
            ownerName: "Molly's Animal Sanctuary", ownerPhone: "9830000001"
        ),
        Pet(
            id: "sample-bruno", name: "Bruno", species: .dog, breed: "Labrador mix", age: "4 years",
            gender: .male, area: "New Town",
            description: "Calm and house-trained. His family moved abroad and couldn't take him along.",
            vaccinated: true, sterilized: true,
            ownerName: "Ananya Roy", ownerPhone: "9830000002"
        ),
        Pet(
            id: "sample-kalu", name: "Kalu", species: .dog, breed: "Indie", age: "8 months",
            gender: .male, area: "Behala",
            description: "Playful puppy rescued from the street. Full of energy and very affectionate.",
            vaccinated: true, sterilized: false,
            ownerName: "Molly's Animal Sanctuary", ownerPhone: "9830000001"
        ),
        Pet(
            id: "sample-snowy", name: "Snowy", species: .cat, breed: "Persian mix", age: "3 years",
            gender: .female, area: "Ballygunge",
            description: "Quiet indoor cat who loves sunny windows. Litter trained.",
            vaccinated: true, sterilized: true,
            ownerName: "Rahul Sen", ownerPhone: "9830000003"
        ),
        Pet(
            id: "sample-tiger", name: "Tiger", species: .cat, breed: "Indian tabby", age: "1 year",
            gender: .male, area: "Jadavpur",
            description: "Curious and friendly. Gets along well with other cats.",
            vaccinated: false, sterilized: false,
            ownerName: "Molly's Animal Sanctuary", ownerPhone: "9830000001"
        ),
        Pet(
            id: "sample-lucy", name: "Lucy", species: .dog, breed: "Beagle", age: "5 years",
            gender: .female, area: "Park Street",
            description: "Sweet senior-in-training. Needs a home with a little garden space.",
            vaccinated: true, sterilized: true,
            ownerName: "Priya Das", ownerPhone: "9830000004"
        ),
        Pet(
            id: "sample-coco", name: "Coco", species: .rabbit, breed: "Dutch rabbit", age: "1 year",
            gender: .female, area: "Dum Dum",
            description: "Soft, shy and loves carrots. Comes with her hutch.",
            vaccinated: false, sterilized: false,
            ownerName: "Sourav Ghosh", ownerPhone: "9830000005"
        ),
        Pet(
            id: "sample-sheru", name: "Sheru", species: .dog, breed: "German Shepherd", age: "3 years",
            gender: .male, area: "Tollygunge",
            description: "Loyal and well trained. Best for an experienced owner with space to run.",
            vaccinated: true, sterilized: false,
            ownerName: "Molly's Animal Sanctuary", ownerPhone: "9830000001"
        ),
    ]
}
