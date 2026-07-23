//
//  DIContainer.swift
//  FoodDelivery
//
//  Created by Sumesh on 23/07/26.
//


import Foundation
import SwiftData

@MainActor
final class DIContainer {
    let apiClient: APIClientProtocol
    let transformService: RestaurantTransformServiceProtocol
    let favoritesStore: FavoritesStoring
    let repository: RestaurantRepository

    init(modelContext: ModelContext) {
        self.apiClient = APIClient()
        self.transformService = RestaurantTransformService()
        self.favoritesStore = FavoritesStore(modelContext: modelContext)
        self.repository = RestaurantRepositoryImpl(
            apiClient: apiClient,
            transformService: transformService,
            favoritesStore: favoritesStore
        )
    }

    func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel(repository: repository, favoritesStore: favoritesStore)
    }

    func makeSearchViewModel() -> SearchViewModel {
        SearchViewModel(repository: repository, favoritesStore: favoritesStore)
    }

    func makeDetailsViewModel(restaurant: Restaurant) -> DetailsViewModel {
        DetailsViewModel(restaurant: restaurant, favoritesStore: favoritesStore)
    }
}
