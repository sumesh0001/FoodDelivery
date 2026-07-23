//
//  HomeView.swift
//  FoodDelivery
//
//  Created by Sumesh on 23/07/26.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    @State private var path = NavigationPath()
    private let container: DIContainer

    init(container: DIContainer) {
        self.container = container
        _viewModel = StateObject(wrappedValue: container.makeHomeViewModel())
    }

    var body: some View {
        NavigationStack(path: $path) {
            content
                .navigationTitle("Nearby Restaurants")
                .navigationDestination(for: Restaurant.self) { restaurant in
                    DetailsView(viewModel: container.makeDetailsViewModel(restaurant: restaurant))
                }
                .task {
                    if case .idle = viewModel.state {
                        await viewModel.loadRestaurants()
                    }
                }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            LoadingView()
        case .loaded(let restaurants):
            restaurantList(restaurants)
        case .empty:
            ScrollView {
                EmptyStateView(
                    title: "No restaurants nearby",
                    message: "Pull to refresh and try again.",
                    systemImage: "fork.knife.circle"
                )
                .frame(minHeight: 500)
            }
            .refreshable { await viewModel.refresh() }
        case .error(let message):
            ErrorView(message: message) {
                Task { await viewModel.loadRestaurants() }
            }
        }
    }

    private func restaurantList(_ restaurants: [Restaurant]) -> some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                SectionHeader(
                    title: "\(restaurants.count) restaurants",
                    subtitle: "Delivering to your current location"
                )
                .padding(.horizontal)

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
        .refreshable { await viewModel.refresh() }
    }
}
