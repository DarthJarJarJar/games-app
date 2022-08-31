//
//  Screenshots.swift
//  Gamescg
//
//  Created by Ayaan  on 2022-08-29.
//

import SwiftUI



struct Screenshots: View {
    @State var screenshots: [Game.Screenshot]
    var body: some View {
        ScrollView(.horizontal) {
            HStack{
                ForEach(screenshots) {
                    screenshot in
                    
                    AsyncImage(url: URL(string: "https://images.igdb.com/igdb/image/upload/t_screenshot_med/\(screenshot.image_id).jpg")) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 320)
                                .aspectRatio(contentMode: .fill)
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .cornerRadius(4)
                                .frame(width: 300)
                            
                        case .failure:
                            VStack(spacing: 4) {
                                Image(systemName: "xmark.circle.fill")
                                Text("Failed to load")
                            }
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 256, maxHeight: 320)
                        @unknown default:
                            EmptyView()
                        }}
                }
            }
            
        }
        .padding()
    }
}

