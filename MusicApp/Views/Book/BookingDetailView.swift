//
//  CancelUserBookingView.swift
//  MusicApp
//
//  Created by Steve on 10/07/2023.
//

import SwiftUI

struct BookingDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var global: Global
    //    @StateObject var vm: UserBookingsVM
    @StateObject var vm: BookingDetailVM
    @Binding var reloadUserBookings: Bool
    
    
    init(bookingDetail: UserBooking, reloadUserBookings: Binding<Bool>) {
        //        _vm = StateObject(wrappedValue: vm)
        _vm = StateObject(wrappedValue: BookingDetailVM(bookingDetail: bookingDetail))
        _reloadUserBookings = reloadUserBookings
    }
    
    var body: some View {
        NavigationView {
            Form {
                
                Section {
                    HStack {
                        Image(systemName: "person.fill")
                            .frame(width: 25)
                        Text(vm.bookingDetail.teacher.fullName)
                    }
                    HStack {
                        Image(systemName: "studentdesk")
                            .frame(width: 25)
                        Text(vm.bookingDetail.student.fullName)
                    }
                    HStack {
                        Image(systemName: "calendar")
                            .frame(width: 25)
                        Text(vm.bookingDetail.parsedStartTime.asMediumDateString())
                    }
                    HStack {
                        Image(systemName: "clock")
                            .frame(width: 25)
                        Text("\(vm.bookingDetail.parsedStartTime.asTime() ?? "") - \(vm.bookingDetail.parsedEndTime.asTime() ?? "")")
                    }
                    HStack {
                        Image(systemName: vm.bookingDetail.instrument.sfSymbol)
                            .frame(width: 25)
                        Text(vm.bookingDetail.instrument.name)
                    }
                    HStack {
                        Image(systemName: "music.note")
                            .frame(width: 25)
                        Text(vm.bookingDetail.grade.name)
                    }
                }
                
                if vm.bookingDetail.parsedStartTime > Date() {
                    Section {
                        TextField("Cancel Reason", text: $vm.cancelReason, axis: .vertical)
                        HStack {
                            Spacer()
                            Button("Cancel Booking", role: .destructive) {
                                
                                Task {
                                    await vm.cancelBooking(token: global.token)
                                    reloadUserBookings = true
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                            .disabled(vm.cancelReason == "")
                            Spacer()
                        }
                    } header: {
                        Text("Cancel Booking")
                    }
                }
                else if vm.bookingDetail.teacherID != global.teacherDetails?.teacherID {
                    Section {
                        RatingView(rating: $vm.review.rating)
                        TextField("Review Details", text: $vm.review.details, axis: .vertical)
                        HStack {
                            Spacer()
                            Button("Save Review") {
                                
                                Task {
                                    await vm.postReview(token: global.token)
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                            .disabled(vm.review.details == "" || vm.review.rating == 0)
                            Spacer()
                        }
                    } header: {
                        Text("Leave Review")
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    closeButton
                }
            }
            .navigationTitle("Booking")
            
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
