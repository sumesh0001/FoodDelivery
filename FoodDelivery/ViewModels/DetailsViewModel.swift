//
//  DetailsViewModel.swift
//  FoodDelivery
//
//  Created by Sumesh on 23/07/26.
//

import Foundation
import Combine

@MainActor
final class DetailsViewModel: ObservableObject {
    @Published private(set) var restaurant: Restaurant
    @Published private(set) var isTogglingFavorite: Bool = false

    private let favoritesStore: FavoritesStoring

    init(restaurant: Restaurant, favoritesStore: FavoritesStoring) {
        self.restaurant = restaurant
        self.favoritesStore = favoritesStore
    }

    func loadFavoriteState() async {
        if let isFavorite = try? await favoritesStore.isFavorite(id: restaurant.id) {
            restaurant.isFavorite = isFavorite
        }
    }

    func toggleFavorite() async {
        isTogglingFavorite = true
        defer { isTogglingFavorite = false }

        let newValue = !restaurant.isFavorite
        do {
            try await favoritesStore.setFavorite(id: restaurant.id, isFavorite: newValue)
            restaurant.isFavorite = newValue
        } catch {
            // Persistence failed — state intentionally left unchanged so the
            // UI reflects reality rather than a false optimistic update.
        }
    }
}

