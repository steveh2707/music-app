//
//  SearchView.swift
//  MusicApp
//
//  Created by Steve on 20/06/2023.
//

import SwiftUI

struct SearchView: View {
    
    @StateObject var vm = SearchVM()
    @State private var hasAppeared = false
    @State private var showLocationSearch: Bool = false
    
    
    var body: some View {
        NavigationView {
            
            VStack(alignment: .leading, spacing: 20) {
                
//                Spacer()
                
                HeadingView()
                    .padding(.top, 11)

                
                VStack(alignment: .leading) {
                    Text("Instrument")
                        .font(.title3)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 5) {
                            ForEach(vm.instruments) { instrument in
                                
                                Button {
                                    if vm.selectedInstrument == instrument {
                                        vm.selectedInstrument = nil
                                    } else {
                                        vm.selectedInstrument = instrument
                                    }
                                    
                                } label: {
                                    VStack {
//                                        Text(instrument.name)
//                                            .foregroundStyle(.white)
//                                            .font(.title)
//                                            .frame(width: 120, height: 120)
//                                            .background(instrument == vm.selectedInstrument ? .red : .gray)
//                                            .cornerRadius(20)
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
                                        .background(instrument == vm.selectedInstrument ? Color.theme.accent : Color.clear) // Color of the border
                                        .cornerRadius(25) // Outer corner radius
                                        
                                        Text(instrument.name)
                                            .foregroundColor(instrument == vm.selectedInstrument ? Color.theme.accent : Color.theme.primaryText)
                                    }
                                }
                                
                            }
                        }
                    }
                }
                
                
                VStack(alignment: .leading) {
                    Text("Grade")
                        .font(.title3)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 5) {
                            ForEach(vm.grades) { grade in
                                Button {
                                    if vm.selectedGrade == grade {
                                        vm.selectedGrade = nil
                                    } else {
                                        vm.selectedGrade = grade
                                    }
                                } label: {
                                    Text(grade.name)
                                        .foregroundStyle(grade == vm.selectedGrade ? Color.theme.accent : Color.theme.primaryText)
                                        .font(.subheadline)
                                        .frame(width: 100, height: 100)
                                        .background(Color.theme.backgroundSecondary)
                                        .cornerRadius(20)
                                        .padding(5) // Width of the border
                                        .background(grade == vm.selectedGrade ? Color.theme.accent : Color.clear) // Color of the border
                                        .cornerRadius(25) // Outer corner radius
                                }
                            }
                        }
                    }
                }
                
                
                
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
                
                
                ZStack {
                    NavigationLink {
                        
                        let searchCriteria = SearchCriteria(
                            userLatitude: vm.selectedLocation?.latitude,
                            userLongitude: vm.selectedLocation?.longitude,
                            instrumentId: vm.selectedInstrument?.instrumentID,
                            gradeRankId: vm.selectedGrade?.rank)
                        
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
                .background(Color.theme.accent)
                .foregroundColor(Color.theme.primaryTextInverse)
                .clipShape(Capsule())
                
                Spacer()
            }
            .padding(.horizontal)
            .sheet(isPresented: $showLocationSearch) {
                LocationFinderView(vm: vm)
            }
            .navigationTitle("Search")
            .task {
                if !hasAppeared {
                    await vm.getConfiguration()
                    hasAppeared = true
                }
            }
        }
    }
    
    //    var body: some View {
    //        NavigationView {
    //                Form {
    //                    HeadingView()
    //                        .listRowBackground(Color.clear)
    ////                        .padding(.bottom, 30)
    //
    //                    Section {
    //                        Picker("Instrument", selection: $vm.selectedInstrument) {
    //                            Text("Any")
    //                                .tag(nil as Instrument?)
    //                            ForEach(vm.instruments) { instrument in
    //                                Text(instrument.name)
    //                                    .tag(instrument as Instrument?)
    //                            }
    //                        }
    //
    //                        Picker("Grade", selection: $vm.selectedGrade) {
    //                            Text("Any")
    //                                .tag(nil as Grade?)
    //                            ForEach(vm.grades) { grade in
    //                                Text(grade.name)
    //                                    .tag(grade as Grade?)
    //                            }
    //                        }
    //
    //                        Button {
    //                            showLocationSearch = true
    //                        } label: {
    //                            HStack {
    //                                Text("Location")
    //                                Spacer()
    //
    //                                if let location = vm.selectedLocation {
    //                                    Text(location.title)
    //                                        .opacity(0.5)
    //                                } else {
    //                                    Image(systemName: "chevron.right")
    //                                }
    //                            }
    //                        }
    //                        .foregroundColor(Color.theme.primaryText)
    //                    }
    //
    //
    //
    //
    //                    Section {
    //
    //                        ZStack {
    //                            NavigationLink {
    //                                let searchCriteria = SearchCriteria(
    //                                    userLatitude: vm.selectedLocation?.latitude,
    //                                    userLongitude: vm.selectedLocation?.longitude,
    //                                    instrumentId: vm.selectedInstrument?.instrumentID,
    //                                    gradeRankId: vm.selectedGrade?.rank)
    //
    //                                SearchResultsView(searchCriteria: searchCriteria)
    //
    //                            } label: {
    //                                EmptyView()
    //                            }
    //                            .opacity(0)
    //                            HStack {
    //                                Spacer()
    //                                Text("Search")
    //                                Spacer()
    //                            }
    //                        }
    //                        .padding()
    //                        .background(Color.theme.accent)
    //                        .foregroundColor(Color.theme.primaryTextInverse)
    //                        .clipShape(Capsule())
    //
    //                    }
    //                    .listRowBackground(Color.clear)
    //
    //            }
    //            .sheet(isPresented: $showLocationSearch) {
    //                LocationFinderView(vm: vm)
    //            }
    //            .navigationTitle("Search")
    //            .task {
    //                if !hasAppeared {
    //                    await vm.getConfiguration()
    //                    hasAppeared = true
    //                }
    //            }
    //        }
    //    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
