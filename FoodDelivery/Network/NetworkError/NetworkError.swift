//
//  NetworkError.swift
//  FoodDelivery
//
//  Created by Sumesh on 23/07/26.
//

import Foundation

enum NetworkError: LocalizedError, Equatable {
    case noInternetConnection
    case invalidURL
    case badServerResponse(statusCode: Int)
    case decodingFailed(String)
    case requestFailed(String)
    case unknown

    var errorDescription: String? {
        switch self {
        case .noInternetConnection:
            return "No internet connection. Please check your network and try again."
        case .invalidURL:
            return "The request URL was invalid."
        case .badServerResponse(let statusCode):
            return "The server returned an unexpected response (status code \(statusCode))."
        case .decodingFailed:
            return "We couldn't process the data received from the server."
        case .requestFailed(let message):
            return message
        case .unknown:
            return "Something went wrong. Please try again."
        }
    }

    /// Maps a raw `Error` (e.g. thrown by `URLSession` or `JSONDecoder`)
    /// into our typed `NetworkError` so callers only ever handle one error type.
    static func map(_ error: Error) -> NetworkError {
        if let networkError = error as? NetworkError {
            return networkError
        }
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost:
                return .noInternetConnection
            case .badURL, .unsupportedURL:
                return .invalidURL
            default:
                return .requestFailed(urlError.localizedDescription)
            }
        }
        if error is DecodingError {
            return .decodingFailed(error.localizedDescription)
        }
        return .unknown
    }
}
