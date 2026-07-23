//
//  RestaurantEndpoint.swift
//  FoodDelivery
//
//  Created by Sumesh on 23/07/26.
//

import Foundation

enum RestaurantEndpoint: Endpoint {
    case fetchAll

    var baseURL: String { "https://jsonplaceholder.typicode.com" }

    var path: String {
        switch self {
        case .fetchAll:
            return "/users"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .fetchAll:
            return .get
        }
    }
}
