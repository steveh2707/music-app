//
//  FavouriteTeachersView.swift
//  MusicApp
//
//  Created by Steve on 14/08/2023.
//

import SwiftUI

/// View to allow users to access the teachers they have previously favourited.
struct FavouriteTeachersView: View {
    
    @EnvironmentObject var global: Global
    @StateObject private var vm = FavouriteTeacherVM()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            if vm.teachers.isEmpty && vm.viewState == .finished {
                NoContentView(description: "You haven't favourited any teachers yet. Teachers can be favourited from search results.")
            } else {
                
                List {
                    Section {
                        resultsSection
                    } header: {
                        Text("\(vm.totalResults ?? 0) results found")
                    }
                }
            }
            
        }
        .overlay {
            if vm.viewState == .fetching {
                ProgressView()
            }
        }
        
        .navigationTitle("Favourites")
        .alert(isPresented: $vm.hasError, error: vm.error) { }
        .task {
            await vm.fetchFavTeachers(token: global.token)
        }
    }
    
    // MARK: VARIABLES/FUNCTIONS
    
    // list of all the teachers favourited with links to profiles.
    private var resultsSection: some View {
        ForEach(vm.teachers, id: \.self) { teacher in
            ZStack {
                NavigationLink {
                    TeacherView(teacherId: teacher.teacherID)
                } label: {
                    EmptyView()
                }
                .opacity(0)
                SearchResultsRowView(teacher: teacher)
            }
            .task {
                if vm.shouldLoadData(id: teacher.id) {
                    await vm.fetchNextSetOfTeachers()
                }
            }
        }
    }
}

// MARK: PREVIEW
struct FavouriteTeachersView_Previews: PreviewProvider {
    static var previews: some View {
        FavouriteTeachersView()
            .environmentObject(dev.globalStudentVM)
    }
}
