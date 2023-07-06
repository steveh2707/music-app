//
//  SearchResultsView.swift
//  MusicApp
//
//  Created by Steve on 16/06/2023.
//

import SwiftUI

struct SearchResultsView: View {
    
    @EnvironmentObject var global: Global
    @StateObject private var vm: SearchResultsVM
    @State private var hasAppeared = false
    
    init(searchCriteria: SearchCriteria) {
        _vm = StateObject(wrappedValue: SearchResultsVM(searchCriteria: searchCriteria))
    }
    
    var body: some View {

        ZStack(alignment: .bottom) {
//                Color.theme.background
//                    .ignoresSafeArea()
                
                if !vm.teachers.isEmpty {
                    
                    List {
                        Section {
                            resultsSection
                        } header: {
                            Text("\(vm.totalResults ?? 0) results found")
                        }
                    }
                    
                }
                
                if vm.viewState == .fetching {
                    ProgressView()
                }
                
            }
            .task {
                if !hasAppeared {
                    await vm.fetchTeachers()
                    hasAppeared = true
                }
            }
            .overlay {
                if vm.viewState == .loading {
                    ProgressView()
                }
            }
            .navigationBarTitle("Results", displayMode: .inline)

    }
    
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

struct SearchResultsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultsView(searchCriteria: SearchCriteria(userLatitude: 1, userLongitude: 2))
    }
}
