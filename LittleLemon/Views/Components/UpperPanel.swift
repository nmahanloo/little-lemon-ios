//
//  UpperPanel.swift
//  LittleLemon
//
//  Created by Nima Mahanloo on 6/8/25.
//

import SwiftUI

struct UpperPanel: View {
    @Binding var searchText: String
    var includeSearch: Bool = true

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Little Lemon")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.yellow)

                    Text("Chicago")
                        .font(.title2)
                        .foregroundColor(.white)

                    Text("We are a family-owned Mediterranean restaurant, focused on traditional recipes served with a modern twist.")
                        .foregroundColor(.white)
                        .font(.body)
                }

                Spacer()

                Image("upperpanelimage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            if includeSearch {
                TextField("Search menu...", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.top, 8)
            }
        }
        .padding()
        .background(Color.green)
    }
}
