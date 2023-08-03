//
//  TeachersReviewsView.swift
//  MusicApp
//
//  Created by Steve on 02/08/2023.
//

import SwiftUI

struct TeachersReviewsView: View {
    @StateObject private var vm = TeacherReviewsVM()
    var teacherId: Int
    
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(vm.reviews) { review in
                    ReviewRowView(review: review)
                }
            }
            .padding(.top, 5)
            .listStyle(.plain)
            .navigationTitle("Teaching Reviews")
            .task {
                await vm.getReviews(teacherId: teacherId)
            }
            .alert(isPresented: $vm.hasError, error: vm.error) { }
        }
    }
}

struct TeachersReviewsView_Previews: PreviewProvider {
    static var previews: some View {
        TeachersReviewsView(teacherId: 1)
    }
}
