//
//  FavoriteRecord.swift
//  FoodDelivery
//
//  Created by Sumesh on 23/07/26.
//


import Foundation
import SwiftData

@Model
final class FavoriteRecord {
    @Attribute(.unique) var restaurantID: Int
    var isFavorite: Bool

    init(restaurantID: Int, isFavorite: Bool = true) {
        self.restaurantID = restaurantID
        self.isFavorite = isFavorite
    }
}