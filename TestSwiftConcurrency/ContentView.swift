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
                Text("""
                     Choosing the Right Approach
                     *Use completion handlers if you're maintaining legacy code or working in an older project.
                     *Use Combine if you're building a reactive system or want declarative handling.
                     *Use Swift Concurrency for modern Swift development.
                     *Use GCD sparingly, mainly for lower-level control or working outside of URLSession.
                """
                ).frame(maxWidth: .infinity).font(.footnote)
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
                Button("Download List Combine") {
                    self.isLoading = true
                    viewModel.fetchDataWithCompine { success, images, error in
                        guard error == nil else {
                            showError = true
                            return
                        }
                        navigateToList = true
                        self.isLoading = false
                    }
                }
                
                Button("Download List async-await") {
                    self.isLoading = true
                    viewModel.fetchDataWithAsync { success, images, error in
                        guard error == nil else {
                            showError = true
                            return
                        }
                        navigateToList = true
                        self.isLoading = false
                    }
                }
                
                Button("Download List GCD") {
                    self.isLoading = true
                    viewModel.fetchDataWithGCD { success, images, error in
                        guard error == nil else {
                            showError = true
                            return
                        }
                        navigateToList = true
                        self.isLoading = false
                    }
                }
                Spacer()
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
