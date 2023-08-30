//
//  LocationFinderView2.swift
//  MusicApp
//
//  Created by Steve on 20/06/2023.
//

import SwiftUI

/// Modal view to allow user to select their location
struct LocationFinderView: View {
    
    // MARK: PROPERTIES
    @Environment(\.presentationMode) var presentationMode
    @StateObject var vm = LocationFinderVM()
    @FocusState private var isFocusedTextField: Bool
    @Binding var selectedLocation: SelectedLocation
    
    // MARK: BODY
    var body: some View {
        NavigationView {
            Form {
                searchInput
                
                List {
//                    useCurrentLocationButton
                    
                    searchResults
                }
                .foregroundColor(Color.theme.primaryText)
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    closeButton
                }
            }
            .navigationTitle("Location")
            .onChange(of: vm.selectedLocation) { newValue in
                if let newValue = newValue {
                    selectedLocation = newValue
                    presentationMode.wrappedValue.dismiss()
                }

            }
        }
    }
    
    // MARK: VARIABLES/FUNCTIONS
    
    /// The input field for searching locations.
    private var searchInput: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Type address", text: $vm.searchableText)
                .autocorrectionDisabled()
                .focused($isFocusedTextField)
                .onReceive(
                    vm.$searchableText.debounce(
                        for: .seconds(0.5),
                        scheduler: DispatchQueue.main
                    )
                ) {
                    vm.searchAddress($0)
                }
                .onAppear {
                    isFocusedTextField = true
                }
            Button {
                vm.searchableText = ""
                vm.results = []
                vm.selectedLocation = nil
            } label: {
                Image(systemName: "multiply.circle.fill")
            }
            .opacity(vm.searchableText.isEmpty ? 0 : 1)
        }
    }
    
//    /// Button to use the user's current location.
//    private var useCurrentLocationButton: some View {
//        Button {
//            // TODO: write code to get users current location
//        } label: {
//            HStack {
//                Image(systemName: "location")
//                Text("Use Current Location")
//            }
//        }
//    }
    
    /// List of search results.
    private var searchResults: some View {
        ForEach(vm.results) { address in
            Button {
                vm.getPlace(from: address)
//                presentationMode.wrappedValue.dismiss()
            } label: {
                VStack(alignment: .leading) {
                    Text(address.title)
                    Text(address.subtitle)
                        .font(.caption)
                }
                
            }
        }
    }
    
    /// Button to close the location finder.
    private var closeButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Image(systemName: "xmark")
                .font(.headline)
        })
    }
    
}
