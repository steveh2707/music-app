//
//  ImagePicker.swift
//  MusicApp
//
//  Created by Steve on 12/07/2023.
//
import PhotosUI
import SwiftUI

struct ImagePicker: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var avatarItem: PhotosPickerItem?
    @State private var data: Data?
    
    var currentImageUrl: String?
    
    var body: some View {
        NavigationView {
            VStack {
                PhotosPicker("Select Photo", selection: $avatarItem, matching: .images)
                    .padding(.bottom, 20)
                if let data = data, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200)
                        .clipShape(Circle())
                        .allowsHitTesting(false)
                    .padding(.top, 20)
                } else if let currentImageUrl {
                    UserImageView(imageURL: currentImageUrl)
                        .frame(width: 200, height: 200)
                        .allowsHitTesting(false)
                }
                Spacer()
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
//                    if data != nil {
                    if let data = data {
                        Button("SAVE") {
                            // TODO: Post photo to backend
                            
                            Task {
                                do {

                                    let imageString: String = data.base64EncodedString()
                                    
                                    let paramStr: String = "image=\(imageString)"
                                    let paramData: Data = paramStr.data(using: .utf8) ?? Data()
                                    
                                    try await NetworkingManager.shared.request(.image(submissionData: paramData))


                                } catch {

                                }
                            }
                        
                            }
                            

                            
                        }
//                    }

                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    closeButton
                }
            }
        }
        .onChange(of: avatarItem) { _ in
            avatarItem?.loadTransferable(type: Data.self) { result in
                
                switch result {
                case .success(let data):
                    if let data = data {
                        self.data = data
                    } else {
                        self.data = nil
                        print("Data is nil")
                    }
                case .failure(let failure):
                    self.data = nil
                    print("\(failure)")
                }
            }
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

struct ImagePicker_Previews: PreviewProvider {
    static var previews: some View {
        ImagePicker()
    }
}
