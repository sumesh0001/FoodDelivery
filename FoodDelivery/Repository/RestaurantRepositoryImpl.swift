//
//  RestaurantRepositoryImpl.swift
//  FoodDelivery
//
//  Created by Sumesh on 23/07/26.
//


import Foundation

final class RestaurantRepositoryImpl: RestaurantRepository {
    private let apiClient: APIClientProtocol
    private let transformService: RestaurantTransformServiceProtocol
    private let favoritesStore: FavoritesStoring

    init(
        apiClient: APIClientProtocol,
        transformService: RestaurantTransformServiceProtocol,
        favoritesStore: FavoritesStoring
    ) {
        self.apiClient = apiClient
        self.transformService = transformService
        self.favoritesStore = favoritesStore
    }

    func fetchRestaurants() async throws -> [Restaurant] {
        let users: [RemoteUser] = try await apiClient.request(RestaurantEndpoint.fetchAll)
        let restaurants = transformService.transform(users)
        let favoriteIDs = (try? await favoritesStore.favoriteIDs()) ?? []
        return restaurants.map { restaurant in
            var copy = restaurant
            copy.isFavorite = favoriteIDs.contains(restaurant.id)
            return copy
        }
    }

    func fetchRestaurant(id: Int) async throws -> Restaurant? {
        let restaurants = try await fetchRestaurants()
        return restaurants.first { $0.id == id }
    }
}
