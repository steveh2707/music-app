//
//  TeacherView.swift
//  MusicApp
//
//  Created by Steve on 13/06/2023.
//

import SwiftUI

struct TeacherView: View {
    
    let teacherId: Int
    @StateObject private var vm = TeacherVM()
    @State private var hasAppeared = false
    
    var body: some View {
        NavigationStack {
            
            ZStack {
                // add background colour
                
                if vm.isLoading {
                    ProgressView()
                } else {
                    ScrollView {
                        if let teacher = vm.teacherDetails {
                            Text(teacher.firstName)
                            Text(teacher.lastName)
                            Text(teacher.bio)
                        }
                    }
                }
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    refresh
                }
            }
            .task {
                if !hasAppeared {
                    await vm.getTeacherDetails(teacherId: teacherId)
                    hasAppeared = true
                }
            }
            .refreshable {
                Task {
                    await vm.getTeacherDetails(teacherId: teacherId)
                }
            }
            .alert(isPresented: $vm.hasError, error: vm.error) {
            }
        }
    }
    
    var refresh: some View {
        Button {
            Task {
                await vm.getTeacherDetails(teacherId: teacherId)
            }
        } label: {
            Image(systemName: "arrow.clockwise")
        }
        .disabled(vm.isLoading)

    }
}

struct TeacherView_Previews: PreviewProvider {
    static var previews: some View {
        TeacherView(teacherId: 1)
    }
}

