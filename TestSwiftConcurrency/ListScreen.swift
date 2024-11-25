//
//  ListScreen.swift
//  TestSwiftConcurrency
//
//  Created by Mohammad Alabed on 24/11/2024.
//

import SwiftUI

struct ListScreen: View {
    
    @EnvironmentObject var viewModel: ListViewModel

    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()) // Two columns
        ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, content: {
                ForEach(viewModel.images, id: \.id) { image in
                    ImageView(id: image.id, title: image.author).onAppear {
                        if image.id == viewModel.images[viewModel.images.count - 2].id {
                            viewModel.fetchImages { success, images, error in
                                
                            }
                        }
                    }
                }
            })
        }
        Spacer()
    }
}

#Preview {
    ListScreen()
}
