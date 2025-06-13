//
//  Dish.swift
//  LittleLemon
//
//  Created by Nima Mahanloo on 6/8/25.
//

import Foundation
import Foundation

struct Dish: Identifiable, Hashable, Decodable {
    let id: Int
    let title: String
    let description: String
    let price: Double
    let image: String
    let category: String

    private enum CodingKeys: String, CodingKey {
        case id, title, description, price, image, category
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        image = try container.decode(String.self, forKey: .image)
        category = try container.decode(String.self, forKey: .category)

        let priceString = try container.decode(String.self, forKey: .price)
        price = Double(priceString) ?? 0.0
    }
}
