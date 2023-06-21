//
//  LocationFinderView2.swift
//  MusicApp
//
//  Created by Steve on 20/06/2023.
//

import SwiftUI

struct LocationFinderView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var vm: SearchVM
    @FocusState private var isFocusedTextField: Bool
    @State private var selectedResult: AddressResult?
    
    var body: some View {
        NavigationView {
            
            Form {
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
                
                List {
                    Button {
                    } label: {
                        Text("Use current Location")
                            .font(.body)
                            .fontWeight(.medium)
                    }
                    ForEach(vm.results) { address in
                        Button {
                            vm.getPlace(from: address)
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            VStack(alignment: .leading) {
                                Text(address.title)
                                Text(address.subtitle)
                                    .font(.caption)
                            }
                            
                        }
                    }
                }
                .foregroundColor(Color.theme.primaryText)
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "xmark")
                            .font(.headline)
                    })
                }
            }
            .navigationTitle("Location")
        }
    }
    
}

struct LocationFinderView_Previews: PreviewProvider {
    static var previews: some View {
        LocationFinderView(vm: SearchVM())
    }
}
