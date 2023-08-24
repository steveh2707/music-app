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
#if DEBUG
        if UITestingHelper.isUITesting {
            let mock: NetworkingManagerImpl = UITestingHelper.isSearchResultsNetworkingSuccessful ? NetworkingManagerTeacherSearchResponseSuccessMock() : NetworkingManagerTeacherSearchResponseFailureMock()
            _vm = StateObject(wrappedValue: SearchResultsVM(networkingManager: mock, searchCriteria: searchCriteria))
        } else {
            _vm = StateObject(wrappedValue: SearchResultsVM(searchCriteria: searchCriteria))
        }
#else
        _vm = StateObject(wrappedValue: SearchResultsVM(searchCriteria: searchCriteria))
#endif
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            if vm.teachers.isEmpty && vm.viewState == .finished {
                NoContentView(description: "Please try a new search.")
            } else {
                List {
                    Section {
                        resultsSection
                    } header: {
                        if let totalResults = vm.totalResults {
                            Text("\(totalResults) results found")
                        }
                    }
                    .accessibilityIdentifier("resultsList")
                }
            }
        }
        .task {
            if !hasAppeared {
                await vm.fetchTeachers()
                hasAppeared = true
            }
        }
        .overlay {
            if vm.viewState == .fetching {
                ProgressView()
            }
        }
        .navigationBarTitle("Results", displayMode: .inline)
        .alert(isPresented: $vm.hasError, error: vm.error) { }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Picker("Sort By", selection: $vm.searchCriteria.selectedSort) {
                    ForEach(vm.searchCriteria.userLatitude != nil ? SearchResultsSort.allCases : SearchResultsSort.allCasesExclLocation, id: \.self) { value in
                        Text(value.sortName)
                            .tag(value)
                    }
                }
            }
        }
        .onAppear {
            global.lessonCost = nil
        }
        .onChange(of: vm.searchCriteria.selectedSort) { newValue in
            Task {
                await vm.fetchTeachers()
            }
        }
        
    }
    
    private var resultsSection: some View {
        ForEach(vm.teachers, id: \.self) { teacher in
            ZStack {
                NavigationLink {
                    TeacherView(teacherId: teacher.teacherID)
                        .onAppear {
                            global.lessonCost = teacher.instrumentTeachable?.lessonCost
                        }
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

//struct SearchResultsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchResultsView(searchCriteria: SearchCriteria(userLatitude: 1, userLongitude: 2))
//    }
//}
