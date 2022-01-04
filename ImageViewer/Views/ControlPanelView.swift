//
//  ControlPanelView.swift
//  ImageViewer
//
//  Created by Sebastian Morado on 1/4/22.
//

import SwiftUI

struct ControlPanelView: View {
    @ObservedObject var imageInfo: ImageInfo
    var isAnimating: Bool 
    
    var body: some View {
        HStack {
            ImageButton(imageInfo: imageInfo, imageName: "minus.magnifyingglass", scaleFunction: "minus")
            ImageButton(imageInfo: imageInfo, imageName: "arrow.up.left.and.down.right.magnifyingglass", scaleFunction: "normal")
            ImageButton(imageInfo: imageInfo, imageName: "plus.magnifyingglass", scaleFunction: "plus")
        }
        .padding(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
        .background(.ultraThinMaterial)
        .cornerRadius(12)
        .opacity(isAnimating ? 1 : 0)
        .animation(.linear(duration: 1), value: isAnimating)
    }
}

struct ImageButton: View {
    @ObservedObject var imageInfo: ImageInfo
    var imageName: String
    var scaleFunction: String
    //var imageScaleChange: CGFloat
    
    var body: some View {
        Button {
            if scaleFunction == "minus" && imageInfo.imageScale > 1 {
                withAnimation(.spring()) {
                    imageInfo.imageScale -= 1
                }
            } else if scaleFunction == "plus" && imageInfo.imageScale < 5 {
                withAnimation(.spring()) {
                    imageInfo.imageScale += 1
                }
            } else {
                withAnimation(.spring()) {
                    imageInfo.imageScale = 1
                    imageInfo.imageOffset = .zero
                }
            }
        } label: {
            Image(systemName: imageName)
                .font(.system(size: 36))
        }
    }
    
}

struct ControlPanelView_Previews: PreviewProvider {
    static var previews: some View {
        ControlPanelView(imageInfo: ImageInfo(), isAnimating: true)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
