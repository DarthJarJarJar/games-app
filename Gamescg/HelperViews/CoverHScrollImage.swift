//
//  CoverImage.swift
//  Gamescg
//
//  Created by Ayaan  on 2022-08-29.
//

import SwiftUI

struct CoverHScrollImage: View {
    @State var width: CGFloat
    @State var imageId: String
    @Namespace var namespace
    var body: some View {
        AsyncImage(url: URL(string: "https://images.igdb.com/igdb/image/upload/t_cover_big/\(imageId).jpg")) { phase in
            switch phase {
            case .empty:
              ProgressView()
                .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 320)
                .aspectRatio(contentMode: .fill)
            case .success(let image):
              image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width)
                .cornerRadius(4)
                
                .matchedGeometryEffect(id: "cover", in: namespace)
            
            case .failure:
              VStack(spacing: 4) {
                Image(systemName: "xmark.circle.fill")
                Text("Failed to load")
              }
              .frame(minWidth: 0, maxWidth: .infinity, minHeight: 256, maxHeight: 320)
            @unknown default:
              EmptyView()
            }
          }
    }
}

struct CoverHScrollImage_Previews: PreviewProvider {
    static var previews: some View {
        CoverHScrollImage(width: 75, imageId: "co4jni")
    }
}
