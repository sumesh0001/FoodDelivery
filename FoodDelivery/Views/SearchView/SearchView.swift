//
//  SearchView.swift
//  FoodDelivery
//
//  Created by Sumesh on 23/07/26.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel: SearchViewModel
    @State private var path = NavigationPath()
    private let container: DIContainer

    init(container: DIContainer) {
        self.container = container
        _viewModel = StateObject(wrappedValue: container.makeSearchViewModel())
    }

    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 0) {
                SearchBar(text: $viewModel.query)
                    .padding()

                content
            }
            .navigationTitle("Search")
            .navigationDestination(for: Restaurant.self) { restaurant in
                DetailsView(viewModel: container.makeDetailsViewModel(restaurant: restaurant))
            }
            .task {
                await viewModel.loadIfNeeded()
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle:
            EmptyStateView(
                title: "Search restaurants",
                message: "Start typing a restaurant name to see results.",
                systemImage: "magnifyingglass"
            )
        case .loading:
            LoadingView()
        case .loaded(let restaurants):
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(restaurants) { restaurant in
                        Button {
                            path.append(restaurant)
                        } label: {
                            RestaurantCardView(restaurant: restaurant)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 24)
            }
        case .empty:
            EmptyStateView(
                title: "No matches",
                message: "Try a different restaurant name.",
                systemImage: "magnifyingglass"
            )
        case .error(let message):
            ErrorView(message: message) {
                Task { await viewModel.loadIfNeeded() }
            }
        }
    }
}
