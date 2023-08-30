//
//  CancelUserBookingView.swift
//  MusicApp
//
//  Created by Steve on 10/07/2023.
//

import SwiftUI

/// Modal view to show the details of an existing booking
struct BookingDetailView: View {
    
    // MARK: PROPERTIES
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var global: Global
    @StateObject var vm: BookingDetailVM
    @Binding var reloadUserBookings: Bool
    
    var currentDate = Date()
    
    // MARK: INITALIZATION
    init(bookingDetail: UserBooking, reloadUserBookings: Binding<Bool>) {
        _vm = StateObject(wrappedValue: BookingDetailVM(bookingDetail: bookingDetail))
        _reloadUserBookings = reloadUserBookings
    }
    
    // MARK: BODY
    var body: some View {
        NavigationView {
            Form {
                
                bookingDetailsSection
                
                // conditional to decide whether the user can cancel the booking or leave a review
                if vm.bookingDetail.parsedStartTime > currentDate.addOrSubtractDays(day: global.bookingCancellationMinDays) || vm.bookingDetail.teacherID == global.teacherDetails?.teacherID {
                    cancelBookingSection
                } else if vm.bookingDetail.parsedStartTime > currentDate {
                    cancellationNotAllowedSection
                } else if vm.bookingDetail.teacherID != global.teacherDetails?.teacherID {
                    leaveReviewSection
                }
            }
            .alert(isPresented: $vm.hasError, error: vm.error) { }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    closeButton
                }
            }
            .navigationTitle("Booking")
            
        }
    }
    
    // details of the booking being shown
    private var bookingDetailsSection: some View {
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
    }
    
    // close the modal view
    private var closeButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Image(systemName: "xmark")
                .font(.headline)
        })
    }
    
    // section to allow user to enter a reason for cancellation and then send the API request to cancel
    private var cancelBookingSection: some View {
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
    
    // section to display to user that they are not able to cancel the booking
    private var cancellationNotAllowedSection: some View {
        Section {
            Text("Students cannot cancel bookings within \(global.bookingCancellationMinDays) days of lesson.")
                .multilineTextAlignment(.center)
                .foregroundColor(.red)
            HStack {
                Spacer()
                Button("Cancel Booking", role: .destructive) {
                    Task {
                        await vm.cancelBooking(token: global.token)
                        reloadUserBookings = true
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .disabled(true)
                Spacer()
            }
        } header: {
            Text("Cancel Booking")
        }
    }
    
    // section to allow user to write a review for a previous lessonn
    private var leaveReviewSection: some View {
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

