//
//  ImageView.swift
//  TestSwiftConcurrency
//
//  Created by Mohammad Alabed on 24/11/2024.
//

import SwiftUI

struct ImageView: View {
    var id: String
    var title: String
    @State private var image: Image? = nil // Holds the downloaded image
    @State private var isLoading = false // Indicates whether the image is being loaded
    @State private var errorMessage: String? = nil // Holds any errors
    
    var body: some View {
        VStack {
            if let image = image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .shadow(radius: 5)
            } else if isLoading {
                ProgressView() // Loading indicator
                    .scaleEffect(1.5)
                    .padding()
            } else {
                Image(systemName: "photo.fill") // Placeholder image
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray) // Placeholder color
                    .padding()
            }
            
            Text(title)
                .font(.headline)
                .padding(.top, 8)
        }
        .onAppear {
            NetworkManager.shared.downloadImage(id: id) { image, error in
                self.image = image
            }
        }
    }
}

#Preview {
    ImageView(id: "22", title: "Mohd")
}
