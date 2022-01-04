//
//  DrawerView.swift
//  ImageViewer
//
//  Created by Sebastian Morado on 1/4/22.
//

import SwiftUI

struct DrawerView: View {
    @State private var isDrawerOpen : Bool = false
    @Binding var isAnimating : Bool
    @Binding var pageIndex : Int
    
    let pages: [Page] = pagesData
    
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
            ForEach(pages) { item in
                Image("thumb-" + item.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80)
                    .cornerRadius(8)
                    .shadow(radius: 4)
                    .opacity(isDrawerOpen ? 1 : 0)
                    .animation(.easeOut(duration: 0.5), value: isDrawerOpen)
                    .onTapGesture {
                        isAnimating = true
                        pageIndex = item.id
                    }
            }
            
            Spacer()
        }
        .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
        .background(.ultraThinMaterial)
        .cornerRadius(12)
        .opacity(isAnimating ? 1 : 0)
        .animation(.linear(duration: 1), value: isAnimating)
        .frame(width: 260)
        .padding(.top, UIScreen.main.bounds.height / 12)
        .offset(x: isDrawerOpen ? 20 : 215)
    }
}

struct DrawerView_Previews: PreviewProvider {
    static var previews: some View {
        DrawerView(isAnimating: .constant(true), pageIndex: .constant(0))
            .preferredColorScheme(.dark)
            .padding()
    }
}
