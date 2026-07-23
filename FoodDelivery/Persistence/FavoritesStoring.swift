//
//  FavoritesStoring.swift
//  FoodDelivery
//
//  Created by Sumesh on 23/07/26.
//


import Foundation

protocol FavoritesStoring: Sendable {
    func favoriteIDs() async throws -> Set<Int>
    func isFavorite(id: Int) async throws -> Bool
    func setFavorite(id: Int, isFavorite: Bool) async throws
}
