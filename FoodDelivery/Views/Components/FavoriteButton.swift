//
//  FavoriteButton.swift
//  FoodDelivery
//
//  Created by Sumesh on 23/07/26.
//

import SwiftUI

struct FavoriteButton: View {
    let isFavorite: Bool
    let isLoading: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(.thinMaterial)
                    .frame(width: 40, height: 40)

                if isLoading {
                    ProgressView()
                        .controlSize(.small)
                } else {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundStyle(isFavorite ? .red : .primary)
                        .symbolEffect(.bounce, value: isFavorite)
                }
            }
        }
        .disabled(isLoading)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isFavorite)
        .accessibilityLabel(isFavorite ? "Remove from favorites" : "Add to favorites")
    }
}

#Preview {
    FavoriteButton(isFavorite: true, isLoading: false, action: {})
        .padding()
}
