//
//  Restaurant.swift
//  FoodDelivery
//
//  Created by Sumesh on 23/07/26.
//

import Foundation

struct Restaurant: Identifiable, Hashable, Sendable {
    let id: Int
    let name: String
    let imageURL: URL?
    let rating: Double
    let distanceInKm: Double
    let deliveryTimeInMinutes: Int
    let description: String
    let cuisine: String

    var isFavorite: Bool = false

    var formattedDistance: String {
        String(format: "%.1f km", distanceInKm)
    }

    var formattedDeliveryTime: String {
        "\(deliveryTimeInMinutes) min"
    }

    var formattedRating: String {
        String(format: "%.1f", rating)
    }
}

extension Restaurant {
    /// Convenience factory for previews / tests.
    static func mock(id: Int = 1, name: String = "The Golden Fork") -> Restaurant {
        Restaurant(
            id: id,
            name: name,
            imageURL: URL(string: "https://picsum.photos/seed/\(id)/600/400"),
            rating: 4.5,
            distanceInKm: 1.2,
            deliveryTimeInMinutes: 25,
            description: "A cozy spot serving contemporary dishes made from locally sourced ingredients, perfect for a quick bite or a relaxed evening meal.",
            cuisine: "Contemporary",
            isFavorite: false
        )
    }
}
