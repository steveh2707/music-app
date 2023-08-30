//
//  MakeBookingView.swift
//  MusicApp
//
//  Created by Steve on 04/07/2023.
//

import SwiftUI

/// View providing user with booking details and allows booking to be created.
struct MakeBookingView: View {
    
    // MARK: PROPERTIES
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var global: Global
    @StateObject var vm: BookingVM
    @State var discountCode: String = ""
    @FocusState var isFocusedTextField: Bool
    
    // MARK: BODY
    var body: some View {
        NavigationView {
            Form {
                bookingDetailsSection

                priceSection
                
                buttonSection
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "xmark")
                            .font(.headline)
                    })
                }
            }
            .alert(isPresented: $vm.hasError, error: vm.error) { }
            .navigationTitle("New Booking")
            .alert("Booking Saved", isPresented: $vm.showSuccessMessage) {
                Button("OK", role: .cancel) {
                    presentationMode.wrappedValue.dismiss()
                    Task {
                        await vm.getTeacherAvailability(token: global.token)
                    }
                }
            }
        }
    }
    
    // details of the selected booking
    private var bookingDetailsSection: some View {
        Section {
            HStack {
                Image(systemName: "person")
                    .frame(width: 25)
                Text(vm.teacher.fullName)
            }
            HStack {
                Image(systemName: "calendar")
                    .frame(width: 25)
                Text(vm.selectedDateTime?.asMediumDateString() ?? "")
            }
            HStack {
                Image(systemName: "clock")
                    .frame(width: 25)
                if let selectedDateTime = vm.selectedDateTime {
                    Text("\(selectedDateTime.asTime() ?? "") - \(selectedDateTime.addOrSubtractMinutes(minutes: 60).asTime() ?? "")")
                }
            }
            HStack {
                Image(systemName: global.selectedInstrument?.sfSymbol ?? "questionmark")
                    .frame(width: 25)
                Text(global.selectedInstrument?.name ?? "")
            }
            HStack {
                Image(systemName: "music.note")
                    .frame(width: 25)
                Text(global.selectedGrade?.name ?? "")
            }
        } header: {
            Text("Booking Details")
        }
    }
    
    // price details of booking
    private var priceSection: some View {
        Section {
            HStack {
                Image(systemName: "sterlingsign")
                    .frame(width: 25)
                Text("\(global.lessonCost ?? 0)")
            }
        } header: {
            Text("Price Details")
        }
    }
    
    // buttons to allow user to make or cancel booking
    private var buttonSection: some View {
        Section {
            Button("Make Booking") {
                Task {
                    await vm.makeBooking(token: global.token, instrumentId: global.selectedInstrument?.instrumentID ?? 0, gradeId: global.selectedGrade?.gradeID ?? 0, priceFinal: global.lessonCost ?? 0)
                }
            }
            Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }
            .tint(Color.theme.red)
        }
    }
}
