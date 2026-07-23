//
//  RootTabView.swift
//  FoodDelivery
//
//  Created by Sumesh on 23/07/26.
//

import SwiftUI

struct RootTabView: View {
    let container: DIContainer

    var body: some View {
        TabView {
            HomeView(container: container)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            SearchView(container: container)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
        }
    }
}
