import SwiftUI
import UIKit

/// The pet's photo, or a friendly species placeholder when no photo was added.
struct PetImage: View {
    let pet: Pet
    var emojiSize: CGFloat = 56

    var body: some View {
        if let fileName = pet.imageFileName,
           let image = UIImage(contentsOfFile: SanctuaryStore.photoURL(for: fileName).path) {
            Color.clear
                .overlay(Image(uiImage: image).resizable().scaledToFill())
                .clipped()
        } else {
            ZStack {
                pet.species.gradient
                Text(pet.species.emoji).font(.system(size: emojiSize))
            }
        }
    }
}

struct PetCard: View {
    let pet: Pet

    var body: some View {
        HStack(spacing: 14) {
            PetImage(pet: pet, emojiSize: 40)
                .frame(width: 88, height: 88)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            VStack(alignment: .leading, spacing: 4) {
                Text(pet.name).font(.headline)
                Text("\(pet.species.label) · \(pet.breed) · \(pet.age)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                AreaLabel(area: pet.area).padding(.top, 2)
            }
            Spacer(minLength: 0)
            Image(systemName: "chevron.right")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
        .padding(12)
        .background(Color.cardBackground, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .contentShape(Rectangle())
    }
}

/// Compact card used in horizontal carousels.
struct PetTile: View {
    let pet: Pet

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            PetImage(pet: pet, emojiSize: 48)
                .frame(width: 150, height: 120)
            VStack(alignment: .leading, spacing: 2) {
                Text(pet.name).font(.headline).lineLimit(1)
                AreaLabel(area: pet.area)
            }
            .padding(10)
        }
        .frame(width: 150, alignment: .leading)
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

struct AreaLabel: View {
    let area: String

    var body: some View {
        HStack(spacing: 2) {
            Image(systemName: "mappin.and.ellipse")
                .font(.caption)
                .foregroundStyle(Color.brandOrange)
            Text("\(area), Kolkata")
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
    }
}

struct InfoPill: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.subheadline.weight(.medium))
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .foregroundStyle(Color.onSecondaryContainer)
            .background(Color.secondaryContainer, in: Capsule())
    }
}

struct FilterChip: View {
    let title: String
    let selected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                if selected { Image(systemName: "checkmark").font(.caption.weight(.bold)) }
                Text(title).font(.subheadline.weight(.medium))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .foregroundStyle(selected ? Color.onPrimaryContainer : Color.primary)
            .background(selected ? Color.primaryContainer : Color.clear, in: Capsule())
            .overlay(Capsule().stroke(selected ? Color.clear : Color.secondary.opacity(0.4)))
        }
        .buttonStyle(.plain)
    }
}

struct ScreenHeader: View {
    let title: String
    var subtitle: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title).font(.largeTitle.bold())
            if let subtitle {
                Text(subtitle).font(.subheadline).foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }
}

/// A flowing row of views that wraps onto new lines (used for the pet info pills).
struct WrappingHStack: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        var x: CGFloat = 0, y: CGFloat = 0, rowHeight: CGFloat = 0, width: CGFloat = 0
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x > 0 && x + size.width > maxWidth {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
            width = max(width, x - spacing)
        }
        return CGSize(width: width, height: y + rowHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX, y = bounds.minY, rowHeight: CGFloat = 0
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x > bounds.minX && x + size.width > bounds.maxX {
                x = bounds.minX
                y += rowHeight + spacing
                rowHeight = 0
            }
            subview.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}

enum Validation {
    static func isValidIndianMobile(_ phone: String) -> Bool {
        let digits = String(phone.filter { $0.isASCII && $0.isNumber }.suffix(10))
        guard digits.count == 10, let first = digits.first else { return false }
        return "6789".contains(first)
    }

    static func isValidEmail(_ email: String) -> Bool {
        let trimmed = email.trimmingCharacters(in: .whitespaces)
        if trimmed.isEmpty { return true }
        return trimmed.range(of: #"^[A-Z0-9a-z._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}$"#, options: .regularExpression) != nil
    }

    /// Keeps only ASCII digits, at most 10 of them.
    static func phoneDigits(_ text: String) -> String {
        String(text.filter { $0.isASCII && $0.isNumber }.prefix(10))
    }
}
