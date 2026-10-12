# Molly's Animal Sanctuary — iOS App

iPhone/iPad app for [Molly's Animal Sanctuary](https://www.mollysanimalsanctuary.org) that helps pets in Kolkata find new homes. It's the iOS version of the Android app and has the same features. No login is needed: open the app and choose whether you want to **adopt** a pet or **rehome** (donate) your own.

## Features

- **Home**: welcome banner, two big choices (*Adopt a Pet* / *Rehome a Pet*), a carousel of pets waiting for a home, and "browse by area" chips for Kolkata neighbourhoods.
- **Adopt**: every animal up for adoption, filterable by animal type (dog, cat, rabbit, bird, other) and by area (Salt Lake, New Town, Park Street, Behala, and more). Tap a pet to see details, call the owner, or send an adoption request.
- **Rehome (Donate)**: owners pick a photo from their library and add basic details (name, type, breed, age, gender, area, vaccinated/sterilized, description, contact). The pet shows up in the Adopt list straight away.
- **My Profile**: name, mobile number, email and area. It's stored on the phone and pre-fills the rehome form and adoption requests. It also lists the pets you're rehoming and the pets you've asked to adopt.

All data stays on the device for now (UserDefaults, plus photos in the app's Documents folder), so the app works fully offline. A sample set of sanctuary animals is included for demos and pitches.

## Tech stack

- Swift + SwiftUI, iOS 16+
- `PhotosPicker` for photos (no photo-library permission prompt needed)
- No third-party dependencies

## Getting started

You need a Mac with **Xcode 16 or newer** (free from the Mac App Store).

```bash
git clone https://github.com/YashSinghal2001/mollys-animal-sanctuary-ios.git
cd mollys-animal-sanctuary-ios
open MollysAnimalSanctuary.xcodeproj
```

In Xcode, pick an iPhone simulator at the top (e.g. *iPhone 16*) and press **Run ▶** (⌘R).

To run on your own iPhone: connect it, select it at the top, then in **Signing & Capabilities** choose your Apple ID as the *Team*. If the bundle ID is already taken, change it to something unique, e.g. `com.yourname.mollys`.

Every push also builds the app on GitHub Actions (macOS runner) to check that it compiles.

## Project structure

```
MollysAnimalSanctuary/
├── MollysAnimalSanctuaryApp.swift   # app entry point
├── Models/          # Pet, Profile, Kolkata areas, sample pets
├── Store/           # SanctuaryStore: on-device storage + filters + tab state
├── Views/           # Home, Adopt, Pet detail, Rehome, Profile, shared components, theme
└── Assets.xcassets  # app icon + accent colour
```

## Next steps (ideas)

- Shared backend (e.g. Firebase) so listings are visible to all users, on both Android and iOS.
- Phone-number OTP verification and admin approval of new listings.
- Push notifications when someone requests to adopt your pet.
