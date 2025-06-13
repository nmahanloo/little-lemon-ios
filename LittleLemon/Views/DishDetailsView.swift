//
//  DishDetailsView.swift
//  LittleLemon
//
//  Created by Nima Mahanloo on 6/8/25.
//

import SwiftUI

struct DishDetailsView: View {
    let dish: Dish

    var body: some View {
        VStack(spacing: 0) {
            TopAppBar(showBackButton: true, showProfileButton: false)

            ScrollView {
                VStack(spacing: 16) {
                    AsyncImage(url: URL(string: dish.image)) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(height: 400)
                                .cornerRadius(12)
                        } else if phase.error != nil {
                            Color.gray.frame(height: 400)
                        } else {
                            ProgressView()
                                .frame(height: 400)
                        }
                    }

                    Text(dish.title)
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)

                    Text(dish.description)
                        .multilineTextAlignment(.center)

                    Text(String(format: "$%.2f", dish.price))
                        .font(.headline)
                        .foregroundColor(.gray)
                }
                .padding()
            }
        }
        .navigationBarHidden(true)
    }
}
