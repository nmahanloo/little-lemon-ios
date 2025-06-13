//
//  LowerPanel.swift
//  LittleLemon
//
//  Created by Nima Mahanloo on 6/8/25.
//

import SwiftUI

struct LowerPanel: View {
    @EnvironmentObject var viewModel: AppViewModel
    @State private var selectedCategory: String? = nil
    var searchText: String

    private let categories = ["Starters", "Mains", "Desserts", "Drinks"]

    var filteredDishes: [Dish] {
        let filtered = viewModel.dishes.filter { dish in
            let matchesSearch = searchText.isEmpty ||
                dish.title.localizedCaseInsensitiveContains(searchText) ||
                dish.description.localizedCaseInsensitiveContains(searchText)

            let matchesCategory = selectedCategory == nil ||
                dish.category.caseInsensitiveCompare(selectedCategory!) == .orderedSame

            return matchesSearch && matchesCategory
        }

        let categoryOrder = ["starters", "mains", "desserts", "drinks"]

        return filtered.sorted {
            let index1 = categoryOrder.firstIndex(of: $0.category.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) ?? Int.max
            let index2 = categoryOrder.firstIndex(of: $1.category.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)) ?? Int.max
            return index1 < index2
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Order for Delivery!")
                .font(.system(size: 24, weight: .bold))
                .padding(.top, 24)
                .padding(.horizontal, 16)

            HStack(spacing: 8) {
                ForEach(categories, id: \.self) { category in
                    Button(action: {
                        selectedCategory = (selectedCategory == category) ? nil : category
                    }) {
                        Text(category)
                            .font(.subheadline)
                            .frame(maxWidth: .infinity, minHeight: 30)
                            .padding(.horizontal, 6)
                            .background(selectedCategory == category ? Color.yellow : Color.gray.opacity(0.2))
                            .foregroundColor(.black)
                            .clipShape(Capsule())
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)

            Divider()
                .background(Color.gray)
                .padding(.horizontal, 16)

            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(filteredDishes.indices, id: \.self) { index in
                        let dish = filteredDishes[index]

                        VStack(spacing: 0) {
                            NavigationLink(destination: DishDetailsView(dish: dish)) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(dish.title)
                                            .font(.headline)
                                            .foregroundColor(.black)

                                        Text(dish.description)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                            .multilineTextAlignment(.leading)

                                        Text(String(format: "$%.2f", dish.price))
                                            .font(.subheadline)
                                            .foregroundColor(.black)
                                    }

                                    Spacer()

                                    AsyncImage(url: URL(string: dish.image)) { phase in
                                        if let image = phase.image {
                                            image
                                                .resizable()
                                                .frame(width: 80, height: 80)
                                                .cornerRadius(8)
                                        } else if phase.error != nil {
                                            Color.red.frame(width: 80, height: 80)
                                        } else {
                                            ProgressView()
                                                .frame(width: 80, height: 80)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 12)
                            }

                            // Divider between dishes
                            if index < filteredDishes.count - 1 {
                                Divider()
                                    .background(Color.gray)
                                    .padding(.horizontal, 16)
                            }
                        }
                    }
                }
                .padding(.top)
            }
        }
    }
}
