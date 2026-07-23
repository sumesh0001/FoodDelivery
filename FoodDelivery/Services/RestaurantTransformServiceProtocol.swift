//
//  RestaurantTransformServiceProtocol.swift
//  FoodDelivery
//
//  Created by Sumesh on 23/07/26.
//


import Foundation

protocol RestaurantTransformServiceProtocol: Sendable {
    func transform(_ users: [RemoteUser]) -> [Restaurant]
}

struct RestaurantTransformService: RestaurantTransformServiceProtocol {
    private let cuisines = [
        "Italian", "Japanese", "Mexican", "Indian", "Mediterranean",
        "American", "Thai", "French", "Korean", "Vegan"
    ]

    private let adjectives = [
        "Golden", "Rustic", "Urban", "Cozy", "Spice", "Blue", "Green",
        "Royal", "Sunset", "Harbor"
    ]

    private let nouns = [
        "Fork", "Table", "Kitchen", "Bistro", "Grill", "Plate", "Garden",
        "Spoon", "Corner", "House"
    ]

    func transform(_ users: [RemoteUser]) -> [Restaurant] {
        users.map(transform)
    }

    func transform(_ user: RemoteUser) -> Restaurant {
        var generator = SeededGenerator(seed: UInt64(user.id))

        let cuisine = cuisines[Int(generator.next() % UInt64(cuisines.count))]
        let adjective = adjectives[Int(generator.next() % UInt64(adjectives.count))]
        let noun = nouns[Int(generator.next() % UInt64(nouns.count))]
        let restaurantName = "\(adjective) \(noun)"

        let rating = Double(Int.random(in: 35...50, using: &generator)) / 10.0
        let distance = Double(Int.random(in: 2...120, using: &generator)) / 10.0
        let deliveryTime = Int.random(in: 15...55, using: &generator)

        let description = "\(restaurantName) brings \(user.address.city) a taste of \(cuisine.lowercased()) cuisine. " +
            "Inspired by \(user.company.catchPhrase.lowercased()), every dish is crafted to \(user.company.bs.lowercased())."

        let imageURL = URL(string: "https://picsum.photos/seed/restaurant\(user.id)/800/600")

        return Restaurant(
            id: user.id,
            name: restaurantName,
            imageURL: imageURL,
            rating: rating,
            distanceInKm: distance,
            deliveryTimeInMinutes: deliveryTime,
            description: description,
            cuisine: cuisine,
            isFavorite: false
        )
    }
}

/// A tiny deterministic PRNG so the same `RemoteUser.id` always produces the
/// same synthesized restaurant attributes across launches and test runs.
struct SeededGenerator: RandomNumberGenerator {
    private var state: UInt64

    init(seed: UInt64) {
        self.state = seed == 0 ? 0xdead_beef : seed
    }

    mutating func next() -> UInt64 {
        // xorshift64*
        state ^= state >> 12
        state ^= state << 25
        state ^= state >> 27
        return state &* 2685821657736338717
    }
}
