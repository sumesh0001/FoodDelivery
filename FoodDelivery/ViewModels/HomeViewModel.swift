//
//  HomeViewModel.swift
//  FoodDelivery
//
//  Created by Sumesh on 23/07/26.
//

import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    enum ViewState: Equatable {
        case idle
        case loading
        case loaded([Restaurant])
        case empty
        case error(String)
    }

    @Published private(set) var state: ViewState = .idle
    @Published private(set) var isRefreshing: Bool = false

    private let repository: RestaurantRepository
    private let favoritesStore: FavoritesStoring
    private var notificationObserver: NSObjectProtocol?

    init(repository: RestaurantRepository, favoritesStore: FavoritesStoring) {
        self.repository = repository
        self.favoritesStore = favoritesStore
        observeFavoriteChanges()
    }

    deinit {
        if let notificationObserver {
            NotificationCenter.default.removeObserver(notificationObserver)
        }
    }

    func loadRestaurants() async {
        state = .loading
        await fetch()
    }

    /// Pull-to-refresh entry point — keeps existing content visible while
    /// refreshing rather than flashing a full-screen spinner.
    func refresh() async {
        isRefreshing = true
        await fetch()
        isRefreshing = false
    }

    private func fetch() async {
        do {
            let restaurants = try await repository.fetchRestaurants()
            state = restaurants.isEmpty ? .empty : .loaded(restaurants)
        } catch {
            let networkError = NetworkError.map(error)
            state = .error(networkError.localizedDescription ?? "Something went wrong.")
        }
    }

    /// Applies an optimistic local favorite toggle, keeping the list in sync
    /// without a full network re-fetch.
    private func observeFavoriteChanges() {
        notificationObserver = NotificationCenter.default.addObserver(
            forName: .favoriteDidChange,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard
                let self,
                let id = notification.userInfo?[FavoriteChangeKey.id] as? Int,
                let isFavorite = notification.userInfo?[FavoriteChangeKey.isFavorite] as? Bool
            else { return }

            Task { @MainActor in
                self.applyFavoriteChange(id: id, isFavorite: isFavorite)
            }
        }
    }

    private func applyFavoriteChange(id: Int, isFavorite: Bool) {
        guard case .loaded(var restaurants) = state,
              let index = restaurants.firstIndex(where: { $0.id == id }) else { return }
        restaurants[index].isFavorite = isFavorite
        state = .loaded(restaurants)
    }
}
