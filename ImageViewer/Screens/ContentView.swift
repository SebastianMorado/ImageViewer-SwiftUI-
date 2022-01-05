//
//  ContentView.swift
//  ImageViewer
//
//  Created by Sebastian Morado on 1/4/22.
//

import SwiftUI

class ImageInfo: ObservableObject {
    @Published var imageScale: CGFloat = 1
    @Published var imageOffset: CGSize = .zero
    @Published var image: UIImage?
    @Published var source: Picker.Source = .library
    @Published var showPicker = false
    @Published var showCameraAlert = false
    @Published var cameraError: Picker.CameraErrorType?
    
    func showPhotoPicker() {
        do {
            if source == .camera {
                try Picker.checkPermissions()
            }
            showPicker = true
        } catch {
            showCameraAlert = true
            cameraError = Picker.CameraErrorType(error: error as! Picker.PickerError)
        }
    }
}

struct ContentView: View {
    //MARK: - Property
    @State var isAnimating: Bool = false
    @ObservedObject var imageInfo = ImageInfo()
    
    
    //MARK: - Function
    
    func resetImageState() {
        return withAnimation(.spring()) {
            imageInfo.imageScale = 1
            imageInfo.imageOffset = .zero
        }
    }
    
    //MARK: - Content
    var body: some View {
        NavigationView {
            ZStack {
                
                Color.clear
                //MARK: - Image
                if let image = imageInfo.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                        .padding()
                        .shadow(color: .black.opacity(0.2), radius: 12, x: 2, y: 2)
                        .opacity(isAnimating ? 1:0)
                        .animation(.linear(duration: 1), value: isAnimating)
                        .offset(x: imageInfo.imageOffset.width, y: imageInfo.imageOffset.height)
                        .scaleEffect(imageInfo.imageScale)
                    //MARK: - Tap gesture
                        .onTapGesture(count: 2) {
                            if imageInfo.imageScale == 1 {
                                withAnimation(.spring()) {
                                    imageInfo.imageScale = 5
                                }
                            } else {
                                resetImageState()
                            }
                        }
                    //MARK: - DragGesture
                        .gesture(
                            DragGesture()
                                .onChanged({ value in
                                    withAnimation(.linear(duration: 1)) {
                                        imageInfo.imageOffset = value.translation
                                    }
                                })
                                .onEnded({ _ in
                                    if imageInfo.imageScale <= 1 {
                                        resetImageState()
                                    }
                                })
                        )
                    //MARK: - Magnification
                        .gesture(
                            MagnificationGesture()
                                .onChanged({ value in
                                    withAnimation(.linear(duration: 1)) {
                                        if imageInfo.imageScale >= 1 && imageInfo.imageScale <= 5 {
                                            imageInfo.imageScale = value
                                        } else if imageInfo.imageScale > 5 {
                                            imageInfo.imageScale = 5
                                        }
                                    }
                                })
                                .onEnded({ value in
                                    withAnimation(.linear(duration: 0.2)) {
                                        if imageInfo.imageScale < 1 {
                                            resetImageState()
                                        } else if imageInfo.imageScale > 5 {
                                            imageInfo.imageScale = 5
                                        }
                                    }
                                })
                        )
                } else {
                    Image(systemName: "photo.fill")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10)
                        .padding()
                        .shadow(color: .black.opacity(0.2), radius: 12, x: 2, y: 2)
                        .opacity(isAnimating ? 1:0)
                        .animation(.linear(duration: 1), value: isAnimating)
                        .frame(minWidth: 0, maxWidth: 150)
                }
                
        
            }
            .sheet(isPresented: $imageInfo.showPicker) {
                ImagePicker(sourceType: imageInfo.source == .library ? .photoLibrary : .camera, selectedImage: $imageInfo.image)
                    .ignoresSafeArea()
            }
            .alert("Error", isPresented: $imageInfo.showCameraAlert, presenting: imageInfo.cameraError, actions: { cameraError in
                cameraError.button}, message: { cameraError in
                    Text(cameraError.message)
                })
            .navigationTitle("Pinch & Zoom")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: {isAnimating = true})
            .overlay(
                InfoPanelView(scale: imageInfo.imageScale, offset: imageInfo.imageOffset)
                    .padding(.horizontal)
                    .padding(.top, 30)
                , alignment: .top
            )
            .overlay(
                ControlPanelView(imageInfo: imageInfo, isAnimating: isAnimating)
                    .padding(.bottom, 30)
                , alignment: .bottom
            )
            .overlay(
                DrawerView(imageInfo: imageInfo, isAnimating: $isAnimating)
                , alignment: .topTrailing
            )
        }
        .navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
