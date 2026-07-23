//
//  FavoritesStore.swift
//  FoodDelivery
//
//  Created by Sumesh on 23/07/26.
//


import Foundation
import SwiftData

@MainActor
final class FavoritesStore: FavoritesStoring {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func favoriteIDs() async throws -> Set<Int> {
        let descriptor = FetchDescriptor<FavoriteRecord>(
            predicate: #Predicate { $0.isFavorite == true }
        )
        let records = try modelContext.fetch(descriptor)
        return Set(records.map { $0.restaurantID })
    }

    func isFavorite(id: Int) async throws -> Bool {
        let descriptor = FetchDescriptor<FavoriteRecord>(
            predicate: #Predicate { $0.restaurantID == id }
        )
        return try modelContext.fetch(descriptor).first?.isFavorite ?? false
    }

    func setFavorite(id: Int, isFavorite: Bool) async throws {
        let descriptor = FetchDescriptor<FavoriteRecord>(
            predicate: #Predicate { $0.restaurantID == id }
        )
        if let existing = try modelContext.fetch(descriptor).first {
            existing.isFavorite = isFavorite
        } else {
            modelContext.insert(FavoriteRecord(restaurantID: id, isFavorite: isFavorite))
        }
        try modelContext.save()

        NotificationCenter.default.post(
            name: .favoriteDidChange,
            object: nil,
            userInfo: [FavoriteChangeKey.id: id, FavoriteChangeKey.isFavorite: isFavorite]
        )
    }
}

/// Lightweight cross-screen sync mechanism: when a favorite is toggled on
/// Details, Home/Search observe this notification and patch their local
/// arrays in place — no full re-fetch required, and every screen stays
/// consistent ("Favorite state updates everywhere").
extension Notification.Name {
    static let favoriteDidChange = Notification.Name("FoodDeliveryApp.favoriteDidChange")
}

enum FavoriteChangeKey {
    static let id = "id"
    static let isFavorite = "isFavorite"
}
