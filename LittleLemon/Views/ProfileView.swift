//
//  ProfileView.swift
//  LittleLemon
//
//  Created by Nima Mahanloo on 6/8/25.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AppViewModel
    @Environment(\.presentationMode) var presentationMode

    @State private var showError = false
    @State private var errorMessage = ""

    @AppStorage("notifyOrderStatus") private var notifyOrderStatus: Bool = false
    @AppStorage("notifyPasswordChanges") private var notifyPasswordChanges: Bool = false
    @AppStorage("notifySpecialOffers") private var notifySpecialOffers: Bool = false
    @AppStorage("notifyNewsletter") private var notifyNewsletter: Bool = false

    @State private var tempFirstName = ""
    @State private var tempLastName = ""
    @State private var tempEmail = ""
    @State private var tempPhoneNumber = ""
    @State private var tempNotifyOrderStatus = false
    @State private var tempNotifyPasswordChanges = false
    @State private var tempNotifySpecialOffers = false
    @State private var tempNotifyNewsletter = false
    @State private var tempProfileImage: UIImage? = nil

    @State private var showPhotoPicker = false
    @State private var selectedItem: PhotosPickerItem? = nil

    var body: some View {
        VStack(spacing: 0) {
            TopAppBar(showBackButton: true, showProfileButton: false)

            ScrollView {
                VStack(spacing: 8) {
                    Text("Personal information")
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    // Avatar label
                    Text("Avatar")
                        .font(.caption)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)

                    // Profile image and buttons
                    HStack(spacing: 20) {
                        ZStack {
                            Circle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 60, height: 60)

                            if let image = tempProfileImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle())
                            } else {
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(.gray)
                            }
                        }
                        .overlay(Circle().stroke(Color.black, lineWidth: 0))

                        HStack(spacing: 12) {
                            Button("Change") {
                                showPhotoPicker = true
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 6)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)

                            Button("Remove") {
                                tempProfileImage = nil
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 6)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                        }

                        Spacer()
                    }
                    
                    Spacer()
                    
                    // Input fields with titles
                    Group {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("First Name")
                                .font(.caption)
                                .bold()
                            TextField("First Name", text: $tempFirstName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Last Name")
                                .font(.caption)
                                .bold()
                            TextField("Last Name", text: $tempLastName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Email")
                                .font(.caption)
                                .bold()
                            TextField("Email", text: $tempEmail)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.emailAddress)
                        }

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Phone Number")
                                .font(.caption)
                                .bold()
                            TextField("Phone Number", text: $tempPhoneNumber)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.phonePad)
                        }
                        Spacer()
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email notifications")
                            .font(.headline)

                        checkboxRow(label: "Order statuses", isChecked: $tempNotifyOrderStatus)
                        checkboxRow(label: "Password changes", isChecked: $tempNotifyPasswordChanges)
                        checkboxRow(label: "Special offers", isChecked: $tempNotifySpecialOffers)
                        checkboxRow(label: "Newsletter", isChecked: $tempNotifyNewsletter)
                        Spacer()
                    }
                    
                    Button("Log out") {
                        notifyOrderStatus = false
                        notifyPasswordChanges = false
                        notifySpecialOffers = false
                        notifyNewsletter = false

                        viewModel.firstName = ""
                        viewModel.lastName = ""
                        viewModel.email = ""
                        viewModel.phoneNumber = ""

                        tempFirstName = ""
                        tempLastName = ""
                        tempEmail = ""
                        tempPhoneNumber = ""
                        tempNotifyOrderStatus = false
                        tempNotifyPasswordChanges = false
                        tempNotifySpecialOffers = false
                        tempNotifyNewsletter = false
                        tempProfileImage = nil

                        deleteSavedProfileImage()
                        viewModel.clearUserDefaults()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.yellow)
                    .foregroundColor(.black)
                    .cornerRadius(10)

                    HStack(spacing: 12) {
                        Button("Discard changes") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.3))
                        .foregroundColor(.red)
                        .cornerRadius(10)

                        Button("Save changes") {
                            if validateInputs() {
                                viewModel.firstName = tempFirstName
                                viewModel.lastName = tempLastName
                                viewModel.email = tempEmail
                                viewModel.phoneNumber = tempPhoneNumber
                                notifyOrderStatus = tempNotifyOrderStatus
                                notifyPasswordChanges = tempNotifyPasswordChanges
                                notifySpecialOffers = tempNotifySpecialOffers
                                notifyNewsletter = tempNotifyNewsletter

                                if let image = tempProfileImage {
                                    saveProfileImage(image)
                                } else {
                                    deleteSavedProfileImage()
                                }

                                viewModel.saveUserDefaults()
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.green)
                        .cornerRadius(10)
                    }

                    if showError {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                    
                    // Spacer(minLength: 40)
                }
                .padding()
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            tempFirstName = viewModel.firstName
            tempLastName = viewModel.lastName
            tempEmail = viewModel.email
            tempPhoneNumber = viewModel.phoneNumber
            tempNotifyOrderStatus = notifyOrderStatus
            tempNotifyPasswordChanges = notifyPasswordChanges
            tempNotifySpecialOffers = notifySpecialOffers
            tempNotifyNewsletter = notifyNewsletter
            loadSavedProfileImage()
        }
        .photosPicker(isPresented: $showPhotoPicker, selection: $selectedItem, matching: .images)
        .onChange(of: selectedItem) { newItem in
            guard let newItem else { return }
            Task {
                if let data = try? await newItem.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    tempProfileImage = image
                }
            }
        }
    }

    private func checkboxRow(label: String, isChecked: Binding<Bool>) -> some View {
        Button(action: { isChecked.wrappedValue.toggle() }) {
            HStack {
                Image(systemName: isChecked.wrappedValue ? "checkmark.square" : "square")
                Text(label)
                Spacer()
            }
        }
        .buttonStyle(PlainButtonStyle())
    }

    private func validateInputs() -> Bool {
        let nameRegex = #"^[A-Za-z\s]+$"#
        let emailRegex = #"^[^@\s]+@[^@\s]+\.[A-Za-z]{2,}$"#
        let phoneRegex = #"^\d{3}-\d{3}-\d{4}$"#

        if tempFirstName.trimmingCharacters(in: .whitespaces).isEmpty ||
            tempLastName.trimmingCharacters(in: .whitespaces).isEmpty ||
            tempEmail.trimmingCharacters(in: .whitespaces).isEmpty ||
            tempPhoneNumber.trimmingCharacters(in: .whitespaces).isEmpty {
            errorMessage = "Please fill in all fields."
            showError = true
            return false
        }

        if tempFirstName.range(of: nameRegex, options: .regularExpression) == nil {
            errorMessage = "Invalid first name format!"
            showError = true
            return false
        }

        if tempLastName.range(of: nameRegex, options: .regularExpression) == nil {
            errorMessage = "Invalid last name format!"
            showError = true
            return false
        }

        if tempEmail.range(of: emailRegex, options: .regularExpression) == nil {
            errorMessage = "Invalid email format."
            showError = true
            return false
        }

        if tempPhoneNumber.range(of: phoneRegex, options: .regularExpression) == nil {
            errorMessage = "Invalid phone number format!"
            showError = true
            return false
        }

        showError = false
        return true
    }

    private func saveProfileImage(_ image: UIImage) {
        if let data = image.jpegData(compressionQuality: 0.8) {
            let url = getProfileImageURL()
            try? data.write(to: url)
        }
    }

    private func loadSavedProfileImage() {
        let url = getProfileImageURL()
        if let data = try? Data(contentsOf: url),
           let image = UIImage(data: data) {
            tempProfileImage = image
        }
    }

    private func deleteSavedProfileImage() {
        let url = getProfileImageURL()
        try? FileManager.default.removeItem(at: url)
    }

    private func getProfileImageURL() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            .appendingPathComponent("user_profile.jpg")
    }
}

