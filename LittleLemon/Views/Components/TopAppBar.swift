//
//  TopAppBar.swift
//  LittleLemon
//
//  Created by Nima Mahanloo on 6/8/25.
//

import SwiftUI

struct TopAppBar: View {
    var showBackButton: Bool
    var showProfileButton: Bool
    @Environment(\.presentationMode) var presentationMode

    // Path to saved profile image
    private var profileImagePath: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            .appendingPathComponent("user_profile.jpg")
    }

    var body: some View {
        ZStack {
            // Centered logo
            Image("littlelemonimgtxt_nobg")
                .resizable()
                .scaledToFit()
                .frame(height: 40)

            HStack {
                // Left side: back button or spacer
                if showBackButton {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                            .frame(width: 44, height: 44)
                    }
                } else {
                    Spacer().frame(width: 44)
                }

                Spacer()

                // Right side: profile button or spacer
                if showProfileButton {
                    NavigationLink(destination: ProfileView()) {
                        if let image = UIImage(contentsOfFile: profileImagePath.path) {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.crop.circle")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.black)
                        }
                    }
                    .frame(width: 44, height: 44)
                } else {
                    Spacer().frame(width: 44)
                }
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 56)
        .background(Color.white)
    }
}
