//
//  DetailsView.swift
//  FoodDelivery
//
//  Created by Sumesh on 23/07/26.
//


import SwiftUI

struct DetailsView: View {
    @StateObject private var viewModel: DetailsViewModel

    init(viewModel: @autoclosure @escaping () -> DetailsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel())
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: viewModel.restaurant.imageURL) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().aspectRatio(contentMode: .fill)
                    default:
                        Rectangle().fill(Color.gray.opacity(0.2))
                    }
                }
                .frame(height: 240)
                .clipped()

                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(viewModel.restaurant.name)
                                .font(.title.bold())
                                .dynamicTypeSize(...DynamicTypeSize.accessibility3)
                            Text(viewModel.restaurant.cuisine)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        FavoriteButton(
                            isFavorite: viewModel.restaurant.isFavorite,
                            isLoading: viewModel.isTogglingFavorite
                        ) {
                            Task { await viewModel.toggleFavorite() }
                        }
                    }

                    HStack(spacing: 16) {
                        RatingView(rating: viewModel.restaurant.rating)
                        Label(viewModel.restaurant.formattedDistance, systemImage: "mappin.and.ellipse")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Label(viewModel.restaurant.formattedDeliveryTime, systemImage: "clock")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    Divider()

                    Text("About")
                        .font(.headline)
                    Text(viewModel.restaurant.description)
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle(viewModel.restaurant.name)
        .navigationBarTitleDisplayMode(.inline)
        .task { await viewModel.loadFavoriteState() }
    }
}
