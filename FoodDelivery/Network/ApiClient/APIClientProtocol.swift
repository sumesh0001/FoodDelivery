//
//  APIClientProtocol.swift
//  FoodDelivery
//
//  Created by Sumesh on 23/07/26.
//

import Foundation

protocol APIClientProtocol: Sendable {
    /// Performs a request against the given endpoint and decodes the
    /// response body into `T`.
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}
