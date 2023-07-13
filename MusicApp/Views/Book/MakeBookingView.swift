//
//  MakeBookingView.swift
//  MusicApp
//
//  Created by Steve on 04/07/2023.
//

import SwiftUI

struct MakeBookingView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var global: Global
    @StateObject var vm: BookingVM
    @State var discountCode: String = ""
    @FocusState var isFocusedTextField: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Image(systemName: "person")
                            .frame(width: 25)
                        Text("\(vm.teacher.firstName) \(vm.teacher.lastName)")
                    }
                    HStack {
                        Image(systemName: "calendar")
                            .frame(width: 25)
                        Text(vm.selectedDate ?? "")
                    }
                    HStack {
                        Image(systemName: "clock")
                            .frame(width: 25)
                        Text(vm.selectedTime ?? "") + Text(" (1 hour)")
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
                

                Section {
                    HStack {
                        Image(systemName: "sterlingsign")
                            .frame(width: 25)
                        Text(String(vm.priceFinal))
                    }
//                    HStack {
//                        Image(systemName: "banknote")
//                            .frame(width: 30)
//                        TextField("Discount Code", text: $discountCode)
//                            .autocorrectionDisabled()
//                            .focused($isFocusedTextField)
//                            .onAppear {
//                                isFocusedTextField = true
//                            }
//                        Button {
//                            discountCode = ""
//                        } label: {
//                            Image(systemName: "multiply.circle.fill")
//                        }
//                        .opacity(discountCode.isEmpty ? 0 : 1)
//                    }
//                    if !discountCode.isEmpty {
//                        Button("Check Code") {
//
//                        }
//                    }
                } header: {
                    Text("Price Details")
                }
                
                Section {
                    Button("Make Booking") {
                        Task {
                            await vm.makeBooking(token: global.token, instrumentId: global.selectedInstrument?.instrumentID ?? 0, gradeId: global.selectedGrade?.gradeID ?? 0)
                        }
                    }
                    Button("Cancel") {
                        
                    }
                    .tint(Color.theme.red)
                }

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
}

//struct MakeBookingView_Previews: PreviewProvider {
//    
//    static var vm = BookingVM()
//    
//    static var previews: some View {
//        MakeBookingView(vm: vm)
//            .environmentObject(dev.globalVM)
//    }
//    
//}
