//
//  RestaurantCardView.swift
//  FoodDelivery
//
//  Created by Sumesh on 23/07/26.
//

import SwiftUI

struct RestaurantCardView: View {
    let restaurant: Restaurant

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: restaurant.imageURL) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        placeholderImage
                    case .empty:
                        RestaurantCardSkeleton()
                            .frame(height: 140)
                    @unknown default:
                        placeholderImage
                    }
                }
                .frame(height: 140)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 16))

                if restaurant.isFavorite {
                    Image(systemName: "heart.fill")
                        .foregroundStyle(.red)
                        .padding(8)
                        .background(.thinMaterial, in: Circle())
                        .padding(8)
                }
            }

            Text(restaurant.name)
                .font(.headline)
                .lineLimit(1)
                .dynamicTypeSize(...DynamicTypeSize.accessibility2)

            Text(restaurant.cuisine)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                RatingView(rating: restaurant.rating)

                Label(restaurant.formattedDistance, systemImage: "mappin.and.ellipse")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Label(restaurant.formattedDeliveryTime, systemImage: "clock")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(12)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.05), radius: 6, y: 3)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(restaurant.name), \(restaurant.cuisine), rated \(restaurant.formattedRating), \(restaurant.formattedDistance) away, \(restaurant.formattedDeliveryTime) delivery")
    }

    private var placeholderImage: some View {
        ZStack {
            Rectangle().fill(Color.gray.opacity(0.2))
            Image(systemName: "photo")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    ScrollView {
        RestaurantCardView(restaurant: .mock())
            .padding()
    }
}

