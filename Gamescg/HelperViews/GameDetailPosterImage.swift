//
//  GameDetailPosterImage.swift
//  Gamescg
//
//  Created by Ayaan  on 2022-08-29.
//

import SwiftUI
import CachedAsyncImage

struct GameDetailPosterImage: View {
    @State var imageId: String
    @Namespace var namespace
    var body: some View {
        CachedAsyncImage(url: URL(string: "https://images.igdb.com/igdb/image/upload/t_cover_big/\(imageId).jpg")) { phase in
            switch phase {
            case .empty:
              ProgressView()
                .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 320)
                .aspectRatio(contentMode: .fill)
            case .success(let image):
              image
                
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.bottom, 30)
                .mask(LinearGradient(gradient: Gradient(colors: [.gray, .gray,.gray.opacity(0.2), .clear.opacity(0)]), startPoint: .top, endPoint: .bottom))
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

struct GameDetailPosterImage_Previews: PreviewProvider {
    static var previews: some View {
        GameDetailPosterImage(imageId: "co4jni")
    }
}
