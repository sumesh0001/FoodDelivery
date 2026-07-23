//
//  SearchViewModel.swift
//  FoodDelivery
//
//  Created by Sumesh on 23/07/26.
//

import Foundation
import Combine

@MainActor
final class SearchViewModel: ObservableObject {
    enum ViewState: Equatable {
        case idle
        case loading
        case loaded([Restaurant])
        case empty
        case error(String)
    }

    @Published var query: String = "" {
        didSet { onQueryChanged() }
    }
    @Published private(set) var state: ViewState = .idle

    private var allRestaurants: [Restaurant] = []
    private let repository: RestaurantRepository
    private let favoritesStore: FavoritesStoring
    private let debouncer = Debouncer(delay: .milliseconds(300))
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

    /// Loads the master restaurant list the first time the Search screen
    /// appears. Cheap to call repeatedly — no-ops if data is already cached.
    func loadIfNeeded() async {
        guard allRestaurants.isEmpty else { return }
        state = .loading
        do {
            allRestaurants = try await repository.fetchRestaurants()
            applyFilter()
        } catch {
            state = .error(NetworkError.map(error).localizedDescription ?? "Something went wrong.")
        }
    }

    private func onQueryChanged() {
        debouncer.run { [weak self] in
            await self?.applyFilterOnMainActor()
        }
    }

    private func applyFilterOnMainActor() async {
        applyFilter()
    }

    private func applyFilter() {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            state = allRestaurants.isEmpty ? .empty : .idle
            return
        }
        let filtered = allRestaurants.filter {
            $0.name.localizedCaseInsensitiveContains(trimmed)
        }
        state = filtered.isEmpty ? .empty : .loaded(filtered)
    }

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
                if let index = self.allRestaurants.firstIndex(where: { $0.id == id }) {
                    self.allRestaurants[index].isFavorite = isFavorite
                }
                if case .loaded(var restaurants) = self.state,
                   let index = restaurants.firstIndex(where: { $0.id == id }) {
                    restaurants[index].isFavorite = isFavorite
                    self.state = .loaded(restaurants)
                }
            }
        }
    }
}
