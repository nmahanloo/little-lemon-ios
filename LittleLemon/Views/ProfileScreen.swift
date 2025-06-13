//
//  ProfileView.swift
//  LittleLemon
//
//  Created by Nima Mahanloo on 6/8/25.
//

import SwiftUI

struct ProfileScreen: View {
    @EnvironmentObject var viewModel: AppViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        VStack {
            TopAppBar(showBackButton: true)

            Text("Profile")
                .font(.title)
                .padding(.top, 40)

            Spacer().frame(height: 20)

            TextField("First Name", text: $viewModel.firstName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)

            TextField("Last Name", text: $viewModel.lastName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)

            TextField("Email", text: $viewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
                .autocapitalization(.none)

            Spacer().frame(height: 20)

            if showError {
                Text(errorMessage)
                    .foregroundColor(.red)
            }

            Button("Update") {
                if validateInputs() {
                    viewModel.saveUserDefaults()
                }
            }
            .padding()
            .background(Color.gray)
            .foregroundColor(.green)
            .cornerRadius(20)

            Spacer().frame(height: 20)

            Button("Log out") {
                viewModel.clearUserDefaults()
            }
            .padding()
            .background(Color.yellow)
            .foregroundColor(.black)
            .cornerRadius(10)

            Spacer()
        }
        .padding()
    }

    private func validateInputs() -> Bool {
        let nameRegex = "^[A-Za-z]+$"
        let emailRegex = "^[^@\\s]+@[^@\\s]+\\.[A-Za-z]{2,3}$"

        if viewModel.firstName.range(of: nameRegex, options: .regularExpression) == nil {
            errorMessage = "First name must be only letters."
            showError = true
            return false
        }

        if viewModel.lastName.range(of: nameRegex, options: .regularExpression) == nil {
            errorMessage = "Last name must be only letters."
            showError = true
            return false
        }

        if viewModel.email.range(of: emailRegex, options: .regularExpression) == nil {
            errorMessage = "Invalid email format."
            showError = true
            return false
        }

        showError = false
        return true
    }
}


