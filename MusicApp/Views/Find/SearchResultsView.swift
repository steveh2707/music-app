//
//  SearchResultsView.swift
//  MusicApp
//
//  Created by Steve on 16/06/2023.
//

import SwiftUI

// View to display results of search and provide links to profiles.
struct SearchResultsView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var global: Global
    @StateObject private var vm: SearchResultsVM
    @State private var hasAppeared = false
    
    // MARK: INITALIZATION
    init(searchCriteria: SearchCriteria) {
        // Conditional initializer to allow mock networking manager to be injected if UI Testing is running.
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
    
    // MARK: BODY
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
    
    // MARK: VARIABLES/FUNCTIONS
    
    // Generates a list of search results witgh navigation links.
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
