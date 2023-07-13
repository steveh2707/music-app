//
//  CancelUserBookingView.swift
//  MusicApp
//
//  Created by Steve on 10/07/2023.
//

import SwiftUI

struct CancelUserBookingView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var global: Global
    @StateObject var vm: UserBookingsVM
    
    
    init(vm: UserBookingsVM) {
        _vm = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        NavigationView {
            Form {
                
                if let booking = vm.bookingToBeDeleted {
                    Section {
                        HStack {
                            Image(systemName: "person")
                                .frame(width: 25)
                            Text("\(booking.teacherFirstName) \(booking.teacherLastName)")
                        }
                        HStack {
                            Image(systemName: "calendar")
                                .frame(width: 25)
                            Text(booking.formattedDate.asMediumDateString())
                        }
                        HStack {
                            Image(systemName: "clock")
                                .frame(width: 25)
                            Text("\(booking.startTime) - \(booking.endTime)")
                        }
                        HStack {
                            Image(systemName: booking.instrumendSfSymbol ?? "questionmark")
                                .frame(width: 25)
                            Text(booking.instrumentName ?? "")
                        }
                        HStack {
                            Image(systemName: "music.note")
                                .frame(width: 25)
                            Text(booking.gradeName ?? "")
                        }

                    }
                    
                    Section {
                        TextField("Cancel Reason", text: $vm.cancelReason, axis: .vertical)
                        HStack {
                            Spacer()
                            Button("Cancel Booking", role: .destructive) {
                                presentationMode.wrappedValue.dismiss()
                                Task {
                                    await vm.cancelBooking(token: global.token)
                                }
                            }
                            .disabled(vm.cancelReason == "")
                            Spacer()
                        }
                    }
                    
                }
                

            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    closeButton
                }
            }
            .navigationTitle("Cancel Booking")
            
        }
    }
    
    
    private var closeButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Image(systemName: "xmark")
                .font(.headline)
        })
    }
}

//struct CancelUserBookingView_Previews: PreviewProvider {
//    static var previews: some View {
//        CancelUserBookingView()
//    }
//}
