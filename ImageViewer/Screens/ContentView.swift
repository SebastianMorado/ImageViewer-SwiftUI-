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
}

struct ContentView: View {
    //MARK: - Property
    @State var isAnimating: Bool = false
    @ObservedObject var imageInfo = ImageInfo()
    
    let pages: [Page] = pagesData
    @State var pageIndex: Int = 0
    
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
                Image(pages[pageIndex].imageName)
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
        
            }
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
                DrawerView(isAnimating: $isAnimating, pageIndex: $pageIndex)
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
