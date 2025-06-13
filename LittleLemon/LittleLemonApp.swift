//
//  LittleLemonApp.swift
//  LittleLemon
//
//  Created by Nima Mahanloo on 6/8/25.
//

import SwiftUI

@main
struct LittleLemonApp: App {
    @StateObject private var viewModel = AppViewModel()

    var body: some Scene {
        WindowGroup {
            if viewModel.isRegistered {
                HomeView()
                    .environmentObject(viewModel)
            } else {
                OnboardingView()
                    .environmentObject(viewModel)
            }
        }
    }
}
