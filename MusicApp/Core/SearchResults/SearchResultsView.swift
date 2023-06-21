//
//  SearchResultsView.swift
//  MusicApp
//
//  Created by Steve on 16/06/2023.
//

import SwiftUI

struct SearchResultsView: View {
    
    @StateObject private var vm: searchResultsVM
    @State private var hasAppeared = false
    
    init(searchCriteria: SearchCriteria) {
        _vm = StateObject(wrappedValue: searchResultsVM(searchCriteria: searchCriteria))
    }
    
    var body: some View {
//        NavigationStack {
            ZStack {
//                Color.theme.background
//                    .ignoresSafeArea()
                
                if !vm.teachers.isEmpty {
                    List {
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
                            
                        }
                    }
                }
            }
            .task {
                if !hasAppeared {
                    print("working")
                    await vm.seachForTeachers()
                    hasAppeared = true
                }
            }
            .navigationBarTitle(Text("Results"), displayMode: .inline)
            
//        }
    }
}

struct SearchResultsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultsView(searchCriteria: SearchCriteria(userLatitude: 1, userLongitude: 2))
    }
}
