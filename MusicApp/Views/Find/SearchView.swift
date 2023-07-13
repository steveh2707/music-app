//
//  SearchView.swift
//  MusicApp
//
//  Created by Steve on 20/06/2023.
//

import SwiftUI

struct SearchView: View {
    
    // MARK: PROPERTIES
    
    @EnvironmentObject var global: Global
    @StateObject var vm = SearchVM()
    @State private var hasAppeared = false
    @State private var showLocationSearch: Bool = false
    
    var searchDisabled: Bool {
        global.selectedInstrument == nil || global.selectedGrade == nil
    }
    
    // MARK: BODY
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                
                HeadingView()
                    .padding(.top, 11)
                
                VStack(alignment: .leading) {
                    Text("Instrument")
                        .font(.title3)
                    instrumentSelector
                }
                
                VStack(alignment: .leading) {
                    Text("Grade")
                        .font(.title3)
                    gradeSelector
                }
                
                locationSelector
                
                searchButton
                
                Spacer()
            }
            .padding(.horizontal)
            .sheet(isPresented: $showLocationSearch) {
                LocationFinderView(vm: vm)
            }
            .navigationTitle("Search")
            .task {
                if !hasAppeared || vm.instruments.isEmpty {
                    await vm.getConfiguration()
                    hasAppeared = true
                }
            }
            
        }
    }
    
    // MARK: VARIABLES
    
    /// This is the instrument selector that holds a horizontal ScrollView
    private var instrumentSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 5) {
                ForEach(vm.instruments) { instrument in
                    
                    Button {
                        if global.selectedInstrument == instrument {
                            global.selectedInstrument = nil
                        } else {
                            global.selectedInstrument = instrument
                        }
                        
                    } label: {
                        VStack {
                            CachedImage(url: instrument.imageUrl) { phase in
                                switch phase {
                                case .empty:
                                    Color
                                        .theme.accent
                                        .overlay {
                                            ProgressView()
                                        }
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                case .failure:
                                    Color
                                        .theme.accent
                                        .opacity(0.75)
                                        .overlay {
                                            Image(systemName: "music.note")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 20)
                                                .foregroundColor(Color.theme.primaryTextInverse)
                                                .opacity(0.5)
                                        }
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            .frame(width: 100, height: 100)
                            .cornerRadius(20)
                            .padding(5) // Width of the border
                            .background(instrument == global.selectedInstrument ? Color.theme.accent : Color.clear) // Color of the border
                            .cornerRadius(25) // Outer corner radius
                            
                            Text(instrument.name)
                                .foregroundColor(instrument == global.selectedInstrument ? Color.theme.accent : Color.theme.primaryText)
                        }
                    }
                    
                }
            }
        }
    }
    
    private var gradeSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 5) {
                ForEach(vm.grades) { grade in
                    Button {
                        if global.selectedGrade == grade {
                            global.selectedGrade = nil
                        } else {
                            global.selectedGrade = grade
                        }
                    } label: {
                        Text(grade.name)
                            .foregroundStyle(grade == global.selectedGrade ? Color.theme.accent : Color.theme.primaryText)
                            .font(.subheadline)
                            .frame(width: 100, height: 100)
                            .background(Color.theme.backgroundSecondary)
                            .cornerRadius(20)
                            .padding(5) // Width of the border
                            .background(grade == global.selectedGrade ? Color.theme.accent : Color.clear) // Color of the border
                            .cornerRadius(25) // Outer corner radius
                    }
                }
            }
        }
    }
    
    private var locationSelector: some View {
        Button {
            showLocationSearch = true
        } label: {
            HStack {
                Text("Location")
                    .font(.title3)
                Spacer()
                if let location = vm.selectedLocation {
                    Text(location.title)
                        .opacity(0.5)
                } else {
                    Image(systemName: "chevron.right")
                }
            }
        }
        .foregroundColor(Color.theme.primaryText)
        .padding(.bottom)
    }
    
    private var searchButton: some View {
        ZStack {
            NavigationLink {
                
                let searchCriteria = SearchCriteria(
                    userLatitude: vm.selectedLocation?.latitude,
                    userLongitude: vm.selectedLocation?.longitude,
                    instrumentId: global.selectedInstrument?.instrumentID,
                    gradeRankId: global.selectedGrade?.rank)
                
                
                SearchResultsView(searchCriteria: searchCriteria)
                
            } label: {
                HStack {
                    Spacer()
                    Text("Search")
                    Spacer()
                }
            }
        }
        .padding()
        .background(searchDisabled ? Color.gray : Color.theme.accent)
        .foregroundColor(Color.theme.primaryTextInverse)
        .clipShape(Capsule())
        .disabled(searchDisabled)
    }
    
}

// MARK: PREVIEW

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
