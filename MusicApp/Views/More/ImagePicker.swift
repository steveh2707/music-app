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
    @EnvironmentObject var global: Global
    @StateObject var vm = ImagePickerVM()
    @State private var avatarItem: PhotosPickerItem?


    var currentImageUrl: String?
    
    var body: some View {
        NavigationView {
            VStack {
                PhotosPicker("Select Photo", selection: $avatarItem, matching: .images)
                    .padding(.bottom, 20)
                if let uiImage = vm.uiImage {
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
                    if vm.uiImage != nil {
                        saveButton
                    }
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
                        DispatchQueue.main.async {
                            vm.uiImage = UIImage(data: data)
                        }
                    } else {
                        vm.uiImage = nil
                        print("Data is nil")
                    }
                case .failure(let failure):
                    vm.uiImage = nil
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
    
    private var saveButton: some View {
        Button("SAVE") {
            Task {
                await vm.uploadImage(token: global.token)
                global.updateImageUrl(url: vm.imageUrl)
            }
            presentationMode.wrappedValue.dismiss()
        }
    }
}

//struct ImagePicker_Previews: PreviewProvider {
//    static var previews: some View {
//        ImagePicker()
//    }
//}
