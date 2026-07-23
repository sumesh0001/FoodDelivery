//
//  RestaurantRepository.swift
//  FoodDelivery
//
//  Created by Sumesh on 23/07/26.
//


import Foundation

protocol RestaurantRepository: Sendable {
    /// Fetches the full restaurant list from the remote source.
    func fetchRestaurants() async throws -> [Restaurant]

    /// Fetches a single restaurant by id (used to refresh Details after a
    /// favorite toggle or pull-to-refresh without re-fetching everything).
    func fetchRestaurant(id: Int) async throws -> Restaurant?
}