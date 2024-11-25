//
//  ContentView.swift
//  TestSwiftConcurrency
//
//  Created by Mohammad Alabed on 24/11/2024.
//

import SwiftUI

struct ContentView: View {
    
    @State var navigateToList = false
    @State var showError = false
    
    @StateObject var viewModel = ListViewModel()
    @State var isLoading = false
    var body: some View {
        NavigationStack {
            VStack {
                Button("Download List URLSession + Closure") {
                    self.isLoading = true
                    viewModel.fetchImages { success, images, error in
                        guard error == nil else {
                            showError = true
                            return
                        }
                        navigateToList = true
                        self.isLoading = false
                    }
                }
            }
            .padding()
            .navigationTitle("Home")
            .navigationDestination(isPresented: $navigateToList) {
                ListScreen().environmentObject(viewModel)
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            }
            
            if isLoading {
                ProgressView()
            }
        }
    }
}

#Preview {
    ContentView()
}
