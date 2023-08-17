//
//  TeacherView.swift
//  MusicApp
//
//  Created by Steve on 13/06/2023.
//

import SwiftUI
import MapKit

struct TeacherView: View {
    
    let teacherId: Int
    
    @EnvironmentObject var global: Global
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm = TeacherVM()

    @State private var showFullDescription: Bool = false
    @State private var showLoginMessage: Bool = false
    @State private var showOwnProfileMessage: Bool = false

    
    var teacherViewingOwnProfile: Bool {
        global.teacherDetails?.teacherID == teacherId
    }
    
    var body: some View {
        ZStack {
            if (vm.teacher != nil) {
                VStack {
                    
                    ScrollView {
                        
                        VStack(alignment: .leading) {
                            headingSection
                            
                            Divider()
                            
                            instrumentSection
                            
                            Divider()
                            
                            aboutSection
                            
                            Divider()
                            
                            locationSection
                            
                            Divider()
                            
                            reviewSection
                        }
                        .padding(.horizontal)
                    }
                    
                    
                    footer
                }
                
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $vm.hasError, error: vm.error) { }
        .alert("You must Sign Up or Sign In to use this feature.", isPresented: $showLoginMessage) {
            Button("Sign Up / Sign In", action: {
                dismiss()
                global.selectedTab = 3
            })
            Button("Cancel", role: .cancel, action: {})
        }
        .alert("Function unavailable on your own profile", isPresented: $showOwnProfileMessage) { }
        .toolbar(.hidden, for: .tabBar)
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                refresh
            }
        }
        .task {
            await vm.getTeacherDetails(teacherId: teacherId)
            if global.isValidated && !teacherViewingOwnProfile {
                await vm.checkIfTeacherHasBeenFavourited(token: global.token, teacherId: teacherId)
            }
        }
        .refreshable {
            Task {
                await vm.getTeacherDetails(teacherId: teacherId)
            }
        }
        .overlay {
            if vm.viewState == .fetching {
                ProgressView()
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
        .disabled(vm.viewState == .fetching)
    }
    
    private var headingSection: some View {
        
        ZStack(alignment: .topTrailing) {
            if let teacher = vm.teacher {
            HStack(alignment: .center) {
                
                    UserImageView(imageURL: teacher.profileImageURL ?? "")
                        .frame(width: 120, height: 120)
                    
                    VStack(alignment: .leading) {
                        Text(teacher.fullName)
                            .font(.title)
                        Text(teacher.tagline)
                            .lineLimit(2)
                            .font(.footnote)
                        HStack(alignment: .center) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text(String(teacher.averageReviewScore))
                                .padding(.horizontal, -5)
                            Text("("+String(teacher.reviews.count) + " Reviews)")
                        }
                        .font(.footnote)
                        .padding(.top, 1)
                    }
                    .padding(.leading, 5)
                    Spacer()
            }
            .padding(.top, 10)
                Button {
                    if teacherViewingOwnProfile {
                        showOwnProfileMessage.toggle()
                    } else if !global.isValidated {
                        showLoginMessage.toggle()
                    } else {
                        Task {
                            await vm.favouriteTeacher(token: global.token, teacherId: teacherId)
                        }
                    }
                    
                    // TODO: Save/ remove from CoreData
                } label: {
                    Image(systemName: vm.favTeacher ? "heart.fill" : "heart")
                        .font(.title)
                        .foregroundColor(.red)
                }
            }

        }
    }
    
    private var instrumentSection: some View {
        VStack(alignment: .leading) {
            if let teacher = vm.teacher {
                Text("Instruments Taught")
                    .font(.headline)
                    .padding(.vertical, 5)
                
                ForEach(teacher.instrumentsTaught) { instrument in
                    InstrumentGradeView(sfSymbol: instrument.sfSymbol, instrumentName: instrument.instrumentName, gradeName: instrument.gradeName, lessonCost: instrument.lessonCost, fixedLength: true)
                }
            }
        }
    }
    
    private var aboutSection: some View {
        VStack(alignment: .leading) {
            if let teacher = vm.teacher {
                Text("About")
                    .font(.headline)
                    .padding(.vertical, 5)
                Text(teacher.bio)
                    .lineLimit(showFullDescription ? nil : 8)
                Button {
                    withAnimation(.easeInOut) {
                        showFullDescription.toggle()
                    }
                } label: {
                    Text(showFullDescription ? "Less" : "Read more...")
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(.vertical, 4)
                }
                .foregroundColor(Color.theme.linkText)
                .padding(.top, -10)
            }
        }
    }
    
    private var locationSection: some View {
        VStack(alignment: .leading) {
            if let teacher = vm.teacher {
                HStack {
                    Text("Location")
                        .font(.headline)
                    
                    Spacer()
                    Text(teacher.locationTitle)
                        .foregroundColor(Color.theme.accent)
                }
                .padding(.vertical, 5)
                
                MapView(latitude: $vm.mapLatitude, longitude: $vm.mapLongitude)
            }
        }
    }
    
    
    
    
    
    private var reviewSection: some View {
        VStack(alignment: .leading) {
            if let teacher = vm.teacher {
                Text("Reviews")
                    .font(.headline)
                    .padding(.vertical, 5)
                
                ForEach(teacher.reviews) { review in
                    ReviewRowView(review: review, showDivider: true)
                }

            }
        }
    }
    
    
    private var footer: some View {
        ZStack {
            Color.theme.accent
                .ignoresSafeArea()
            
            if let teacher = vm.teacher {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        
                        if global.isValidated && !teacherViewingOwnProfile {
                            NavigationLink(destination: ChatView(teacherID: teacher.teacherID)) {
                                footerButton(buttonText: "Chat")
                            }
                            Spacer()
                            NavigationLink(destination: BookingScheduleView(teacher: teacher)) {
                                footerButton(buttonText: "Book Now")
                            }
                        } else {
                            Button {
                                if teacherViewingOwnProfile {
                                    showOwnProfileMessage.toggle()
                                } else {
                                    showLoginMessage.toggle()
                                }
                            } label: {
                                footerButton(buttonText: "Chat")
                            }
                            Spacer()
                            Button {
                                if teacherViewingOwnProfile {
                                    showOwnProfileMessage.toggle()
                                } else {
                                    showLoginMessage.toggle()
                                }
                            } label: {
                                footerButton(buttonText: "Book Now")
                            }
                        }

                        
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
        .padding(.top, -10)
        .frame(height: 50)
    }
    
    private func footerButton(buttonText: String) -> some View {
        Text(buttonText)
            .fontWeight(.semibold)
            .foregroundColor(Color.theme.primaryText)
            .frame(width: 150, height: 35)
            .background(
                Capsule()
                    .fill(Color.theme.background)
            )
    }
    
}

struct TeacherView_Previews: PreviewProvider {
    static var previews: some View {
        TeacherView(teacherId: 1)
            .environmentObject(dev.globalVM)
    }
}

