//
//  ReviewView.swift
//  MusicApp
//
//  Created by Steve on 02/08/2023.
//

import SwiftUI

/// View showing a list of all reviews made by a user.
struct UsersReviewsView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var global: Global
    @StateObject private var vm = UsersReviewsVM()
    
    // MARK: BODY
    var body: some View {
        ZStack {
            if vm.reviews.isEmpty && vm.viewState == .finished {
                NoContentView(description: "You haven't written any reviews yet. Write teacher reviews on any previous booking.")
            } else {
                List {
                    ForEach(vm.reviews) { review in
                        
                        ReviewRowView(review: review)
                    }
                }
                .padding(.top, 5)
                .listStyle(.plain)
            }
        }
        .overlay {
            if vm.viewState == .fetching {
                ProgressView()
            }
        }
        .navigationTitle("My Reviews")
        .alert(isPresented: $vm.hasError, error: vm.error) { }
        .task {
            await vm.getReviews(token: global.token)
        }
        .alert(isPresented: $vm.hasError, error: vm.error) { }
    }
}

// MARK: PREVIEW
struct ReviewView_Previews: PreviewProvider {
    static var previews: some View {
        UsersReviewsView()
            .environmentObject(dev.globalStudentVM)
    }
}
