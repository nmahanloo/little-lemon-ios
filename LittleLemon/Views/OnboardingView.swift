//
//  OnboardingView.swift
//  LittleLemon
//
//  Created by Nima Mahanloo on 6/8/25.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        VStack(spacing: 0) {
            TopAppBar(showBackButton: false, showProfileButton: false)

            UpperPanel(searchText: .constant(""), includeSearch: false)

            VStack(spacing: 20) {
                Text("Let's get to know you")
                    .font(.title)
                    .padding(.top, 20)

                Group {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("First Name")
                            .font(.subheadline)
                        TextField("First Name", text: $viewModel.firstName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.words)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Last Name")
                            .font(.subheadline)
                        TextField("Last Name", text: $viewModel.lastName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.words)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Email")
                            .font(.subheadline)
                        TextField("address@domain.xxx", text: $viewModel.email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Phone Number")
                            .font(.subheadline)
                        TextField("123-456-7890", text: $viewModel.phoneNumber)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.phonePad)
                            .autocapitalization(.none)
                    }
                }

                Button("Register") {
                    if validateInputs() {
                        viewModel.saveUserDefaults()
                        viewModel.isRegistered = true
                    }
                }
                .padding()
                .background(Color.yellow)
                .foregroundColor(.black)
                .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.top, 16)
            
            if showError {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.top, 16)
            }
            
            Spacer()
    
        }
    }

    private func validateInputs() -> Bool {
        let nameRegex = #"^[A-Za-z\s]+$"#
        let emailRegex = #"^[^@\s]+@[^@\s]+\.[A-Za-z]{2,}$"#
        let phoneRegex = #"^\d{3}-\d{3}-\d{4}$"#

        if viewModel.firstName.trimmingCharacters(in: .whitespaces).isEmpty ||
            viewModel.lastName.trimmingCharacters(in: .whitespaces).isEmpty ||
            viewModel.email.trimmingCharacters(in: .whitespaces).isEmpty ||
            viewModel.phoneNumber.trimmingCharacters(in: .whitespaces).isEmpty {
            errorMessage = "Please fill in all fields."
            showError = true
            return false
        }

        if viewModel.firstName.range(of: nameRegex, options: .regularExpression) == nil {
            errorMessage = "Invalid first name format!"
            showError = true
            return false
        }

        if viewModel.lastName.range(of: nameRegex, options: .regularExpression) == nil {
            errorMessage = "Invalid last name format!"
            showError = true
            return false
        }

        if viewModel.email.range(of: emailRegex, options: .regularExpression) == nil {
            errorMessage = "Invalid email format."
            showError = true
            return false
        }

        if viewModel.phoneNumber.range(of: phoneRegex, options: .regularExpression) == nil {
            errorMessage = "Invalid phone number format!"
            showError = true
            return false
        }

        showError = false
        return true
    }
}
