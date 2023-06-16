//
//  SearchResultsView.swift
//  MusicApp
//
//  Created by Steve on 16/06/2023.
//

import SwiftUI

struct SearchResultsView: View {
    @StateObject private var vm = searchResultsVM()
    @State private var hasAppeared = false
    
    var body: some View {
        NavigationStack {
            ZStack {
//                Color.theme.background
//                    .ignoresSafeArea()
                
                if !vm.teachers.isEmpty {

                    ScrollView(showsIndicators: false) {

                        ForEach(vm.teachers) { teacher in
                            
                            
                            NavigationLink {
                                TeacherView(teacherId: teacher.teacherID)
                            } label: {
                                HStack(alignment: .center) {

                                        Circle()
                                            .frame(width: 110)
                                        
                                        VStack(alignment: .leading) {
                                            Text("\(teacher.firstName) \(teacher.lastName)")
                                                .font(.title)
                                            Text(teacher.tagline)
                                                .lineLimit(2)
                                                .font(.footnote)
                                            HStack(alignment: .center) {
                                                Image(systemName: "star.fill")
                                                Text(String(teacher.averageReviewScore))
                                                    .padding(.horizontal, -5)
                                            }
                                            .font(.footnote)
                                            .padding(.top, 2)
                                        }
                                        .padding(.leading, 5)
                                        Spacer()
                                    }
                                
                            }

                            
//                            Text(teacher.firstName)
                        }


                    }
                    .padding(.horizontal)

                }
                
            }
            .task {
                if !hasAppeared {
                    print("working")
                    await vm.seachForTeachers()
                    hasAppeared = true
                }
            }
            
        }
    }
}

struct SearchResultsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultsView()
    }
}
