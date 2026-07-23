//
//  RatingView.swift
//  FoodDelivery
//
//  Created by Sumesh on 23/07/26.
//

import SwiftUI

struct RatingView: View {
    let rating: Double

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
                .foregroundStyle(.yellow)
                .font(.caption)
            Text(String(format: "%.1f", rating))
                .font(.caption.bold())
                .foregroundStyle(.primary)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Rating \(String(format: "%.1f", rating)) out of 5")
    }
}

#Preview {
    RatingView(rating: 4.5)
        .padding()
}
