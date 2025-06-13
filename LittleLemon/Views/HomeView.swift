//
//  HomeView.swift
//  LittleLemon
//
//  Created by Nima Mahanloo on 6/8/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @State private var searchText: String = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                TopAppBar(showBackButton: false, showProfileButton: true)

                // Static header section with logo, title, and search
                UpperPanel(searchText: $searchText, includeSearch: true)

                // Scrollable item list only
                LowerPanel(searchText: searchText)
            }
            .navigationBarHidden(true)
        }
    }
}
