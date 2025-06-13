//
//  AppViewModel.swift
//  LittleLemon
//
//  Created by Nima Mahanloo on 6/8/25.
//

import Foundation
import Combine

class AppViewModel: ObservableObject {
    @Published var isRegistered: Bool = false
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var email: String = ""
    @Published var phoneNumber: String = ""
    @Published var dishes: [Dish] = []

    init() {
        loadUserDefaults()
        fetchMenu()
    }

    func loadUserDefaults() {
        let defaults = UserDefaults.standard
        self.isRegistered = defaults.bool(forKey: "is_registered")
        self.firstName = defaults.string(forKey: "first_name") ?? ""
        self.lastName = defaults.string(forKey: "last_name") ?? ""
        self.email = defaults.string(forKey: "email") ?? ""
        self.phoneNumber = defaults.string(forKey: "phone_number") ?? ""
    }

    func saveUserDefaults() {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "is_registered")
        defaults.set(firstName, forKey: "first_name")
        defaults.set(lastName, forKey: "last_name")
        defaults.set(email, forKey: "email")
        defaults.set(phoneNumber, forKey: "phone_number")
        isRegistered = true
    }

    func clearUserDefaults() {
        let defaults = UserDefaults.standard

        defaults.removeObject(forKey: "is_registered")
        defaults.removeObject(forKey: "first_name")
        defaults.removeObject(forKey: "last_name")
        defaults.removeObject(forKey: "email")
        defaults.removeObject(forKey: "phone_number")
        defaults.removeObject(forKey: "notifyOrderStatus")
        defaults.removeObject(forKey: "notifyPasswordChanges")
        defaults.removeObject(forKey: "notifySpecialOffers")
        defaults.removeObject(forKey: "notifyNewsletter")

        deleteSavedProfileImage()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.isRegistered = false
            self.firstName = ""
            self.lastName = ""
            self.email = ""
            self.phoneNumber = ""
        }
    }

    private func deleteSavedProfileImage() {
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?
            .appendingPathComponent("user_profile.jpg")

        if let url = fileURL, FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.removeItem(at: url)
        }
    }

    func fetchMenu() {
        guard let url = URL(string: "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json") else {
            print("Invalid URL.")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching menu: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data received.")
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(MenuResponse.self, from: data)
                DispatchQueue.main.async {
                    self.dishes = decodedData.menu
                }
            } catch {
                print("Decoding error: \(error)")
            }
        }.resume()
    }

    func getDish(by id: Int) -> Dish? {
        return dishes.first { $0.id == id }
    }
}
