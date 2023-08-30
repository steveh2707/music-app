//
//  SearchView.swift
//  MusicApp
//
//  Created by Steve on 20/06/2023.
//

import SwiftUI

/// View to allow user to select search parameters
struct SearchView: View {
    
    // MARK: PROPERTIES
    @EnvironmentObject var global: Global
    @State var selectedLocation: SelectedLocation = SelectedLocation(title: "", latitude: 200, longitude: 200)
    @State var searchCrtieria: SearchCriteria?
    
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
                LocationFinderView(selectedLocation: $selectedLocation)
            }
            .alert(isPresented: $global.hasError, error: global.error) { }
            .navigationTitle("Search")
            .task {
                if global.instruments.isEmpty {
                    await global.getConfiguration()
                }
            }
            
        }
    }
    
    // MARK: VARIABLES
    
    /// Instrument selector variable that holds a horizontal ScrollView for each instrument
    private var instrumentSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 5) {
                ForEach(global.instruments) { instrument in
                    
                    Button {
                        if global.selectedInstrument == instrument {
                            global.selectedInstrument = nil
                        } else {
                            global.selectedInstrument = instrument
                        }
                    } label: {
                        instrumentItemView(instrument: instrument)
                    }
                    .accessibilityIdentifier("instrument_\(instrument.id)")
                }
            }
        }
        .accessibilityIdentifier("instrumentsScrollView")
    }
    
    
    /// Returns a view for each instrument based on the instrument variable passed in.
    /// - Parameter instrument: instrument to be displayed.
    /// - Returns: View of the instrument 
    private func instrumentItemView(instrument: Instrument) -> some View {
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
    
    /// Grade selector variable that holds a horizontal ScrollView for each grade
    private var gradeSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 5) {
                ForEach(global.grades) { grade in
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
                    .accessibilityIdentifier("grade_\(grade.id)")
                }
            }
        }
        .accessibilityIdentifier("gradesScrollView")
    }
    
    /// Location selector variable displays a modal screen for the user to select their location.
    private var locationSelector: some View {
        Button {
            showLocationSearch = true
        } label: {
            HStack {
                Text("Location")
                    .font(.title3)
                Spacer()
                if selectedLocation.title != "" {
                    Text(selectedLocation.title)
                        .opacity(0.5)
                } else {
                    Image(systemName: "chevron.right")
                }
            }
        }
        .foregroundColor(Color.theme.primaryText)
        .padding(.bottom)
    }
    
    /// Search button view. Creates a NavigationLink to SearchResultsView passing in all the variables selected in this view.
    private var searchButton: some View {
        ZStack {
            NavigationLink {
                
                let searchCriteria = SearchCriteria(
                    userLatitude: selectedLocation.latitude == 200 ? nil : selectedLocation.latitude,
                    userLongitude: selectedLocation.longitude == 200 ? nil : selectedLocation.longitude,
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
            .accessibilityIdentifier("searchButton")
        }
        .padding()
        .background(searchDisabled ? Color.gray : Color.theme.accent)
        .foregroundColor(Color.theme.primaryTextInverse)
        .clipShape(Capsule())
        .disabled(searchDisabled)
    }
    
}

