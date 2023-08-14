//
//  ReviewView.swift
//  MusicApp
//
//  Created by Steve on 02/08/2023.
//

import SwiftUI

struct UsersReviewsView: View {
    
    @EnvironmentObject var global: Global
    @StateObject private var vm = UsersReviewsVM()
    
    var body: some View {
        ZStack {
            
            if vm.reviews.isEmpty && vm.viewState == .finished {
                NoContentView(description: "You haven't written any reviews yet. Write teacher reviews on any previous booking.")
            } else {
                
                List {
                    ForEach(vm.reviews) { review in
                        
                        ReviewRowView(review: review)
                            .swipeActions(allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    //TODO: Delete
                                } label: {
                                    Label("Delete", systemImage: "trash.fill")
                                }
                                
                                Button {
                                    //TODO: Edit
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                }
                                .tint(Color.theme.accent)
                            }
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
    }
}

struct ReviewView_Previews: PreviewProvider {
    static var previews: some View {
        UsersReviewsView()
            .environmentObject(dev.globalVM)
    }
}
