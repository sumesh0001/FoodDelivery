//
//  RemoteUser.swift
//  FoodDelivery
//
//  Created by Sumesh on 23/07/26.
//

import Foundation

struct RemoteUser: Decodable, Sendable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let address: RemoteAddress
    let phone: String
    let website: String
    let company: RemoteCompany
}

struct RemoteAddress: Decodable, Sendable {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
    let geo: RemoteGeo
}

struct RemoteGeo: Decodable, Sendable {
    let lat: String
    let lng: String
}

struct RemoteCompany: Decodable, Sendable {
    let name: String
    let catchPhrase: String
    let bs: String
}
