//
//  DrawerView.swift
//  ImageViewer
//
//  Created by Sebastian Morado on 1/4/22.
//

import SwiftUI

struct DrawerView: View {
    @ObservedObject var imageInfo: ImageInfo
    @State private var isDrawerOpen : Bool = false
    @Binding var isAnimating : Bool
    
    
    var body: some View {
        HStack(spacing: 12) {
            //MARK: - Drawer handle
            Image(systemName: isDrawerOpen ? "chevron.compact.right" : "chevron.compact.left")
                .resizable()
                .scaledToFit()
                .frame(height: 40)
                .padding(8)
                .foregroundStyle(.secondary)
                .onTapGesture {
                    withAnimation {
                        isDrawerOpen.toggle()
                    }
                }
            
            //MARK: - Thumbnails
            Button {
                //Camera
                imageInfo.source = .camera
                imageInfo.showPhotoPicker()
            } label: {
                Image(systemName: "camera.fill")
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal)
                    .frame(maxHeight: 40)
            }
            Button {
                //Photos
                imageInfo.source = .library
                imageInfo.showPhotoPicker()
            } label: {
                Image(systemName: "photo.fill.on.rectangle.fill")
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal)
                    .frame(maxHeight: 40)
            }

            
            Spacer()
        }
        .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
        .background(.ultraThinMaterial)
        .cornerRadius(12)
        .opacity(isAnimating ? 1 : 0)
        .animation(.linear(duration: 1), value: isAnimating)
        .frame(width: 260, height: 100)
        .padding(.top, UIScreen.main.bounds.height / 12)
        .offset(x: isDrawerOpen ? 20 : 215)
    }
}

struct DrawerView_Previews: PreviewProvider {
    static var previews: some View {
        DrawerView(imageInfo: ImageInfo(), isAnimating: .constant(true))
            .preferredColorScheme(.dark)
            .padding()
    }
}
