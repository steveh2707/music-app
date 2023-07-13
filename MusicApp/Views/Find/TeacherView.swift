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
    @State private var hasAppeared = false
    @State private var showFullDescription: Bool = false
    @State private var showLoginMessage: Bool = false
    
    var body: some View {
        ZStack {
            //                Color.theme.background
            //                    .ignoresSafeArea()
            
            if (vm.teacher != nil) {
                VStack {
                    
                    ScrollView(showsIndicators: false) {
                        
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
                        
                    }
                    .padding(.horizontal)
                    
                    footer
                }
                
            }
            //                }
        }
        .alert(isPresented: $vm.hasError, error: vm.error) { }
        .alert("You must Sign In", isPresented: $showLoginMessage) {
            Button("Sign In / Sign Up", action: {
                dismiss()
                global.selectedTab = 3
            })
            Button("Cancel", role: .cancel, action: {})
        }
        
        .toolbar(.hidden, for: .tabBar)
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
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
        HStack(alignment: .center) {
            if let teacher = vm.teacher {
                UserImageView(imageURL: teacher.profileImageURL ?? "")
                    .frame(width: 110, height: 110)
                
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
                        Text("("+String(teacher.reviews.count) + " Reviews)")
                    }
                    .font(.footnote)
                    .padding(.top, 2)
                }
                .padding(.leading, 5)
                Spacer()
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
                    InstrumentGradeView(sfSymbol: instrument.sfSymbol, instrumentName: instrument.instrumentName, gradeName: instrument.gradeName, showGradeFrom: false, fixedLength: true)
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
            
            Text("Location")
                .font(.headline)
                .padding(.vertical, 5)
            
            Map(coordinateRegion: .constant(vm.mapRegion), interactionModes: [], annotationItems: vm.locations) { location in
                MapMarker(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
                
            }
            .frame(maxWidth: .infinity)
            .frame(height: 200)
        }
    }
    
    
    
    
    
    private var reviewSection: some View {
        VStack(alignment: .leading) {
            if let teacher = vm.teacher {
                Text("Reviews")
                    .font(.headline)
                    .padding(.vertical, 5)
                
                ForEach(teacher.reviews) { review in
                    VStack {
                        
                        HStack(alignment: .center) {
                            
                            UserImageView(imageURL: "")
                                .frame(width: 70)
                            
                            
                            VStack(alignment: .leading) {
                                Text("\(review.firstName) \(review.lastName)")
                                
                                let date = Date(mySqlDateTimeString: review.createdTimestamp)
                                Text(date.asMediumDateString())
                                    .font(.callout)
                                    .foregroundColor(Color("SecondaryTextColor"))
                                
                                
                                HStack(alignment: .center) {
                                    Image(systemName: review.sfSymbol)
                                        .frame(width: 25)
                                    Text(review.instrumentName)
                                        .frame(width: 60)
                                    Text(review.gradeName)
                                        .foregroundColor(Color.theme.primaryTextInverse)
                                        .font(.footnote)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 2)
                                        .background(
                                            Capsule()
                                                .fill(Color.theme.accent)
                                        )
                                }
                                .padding(.top, -5)
                            }
                            Spacer()
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                Text(String(review.numStars))
                                    .padding(.leading, -5)
                            }
                            .font(.title3)
                        }
                        Text(review.details)
                        Divider()
                    }
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

                        if global.isValidated {
                            NavigationLink {
                                ChatView(teacherId: teacher.teacherID)
                            } label: {
                                footerButton(buttonText: "Chat")
                            }
                            Spacer()
                            NavigationLink {
                                BookingView(teacher: teacher)
                            } label: {
                                footerButton(buttonText: "Book Now")
                            }
                        } else {
                            Button {
                                showLoginMessage = true
                            } label: {
                                footerButton(buttonText: "Chat")
                            }
                            Spacer()
                            Button {
                                showLoginMessage = true
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

