//
//  GameReviews.swift
//  Gamescg
//
//  Created by Ayaan Shahab on 2022-09-03.
//

import SwiftUI

struct GameReviews: View {
    @State var reviews: [Review]
    @State var showSpoiler: Bool = false
    var body: some View {
      
        VStack {
            if reviews != [] {
                ForEach(reviews) { rev in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 0.5)
                            .foregroundColor(.white)
                        
                        
                        VStack(alignment: .leading) {
                            Text(rev.reviewBy ?? "nO name")
                                .font(.title3)
                                .bold()
                            HStack(spacing: 2) {
                                ForEach(1..<((rev.rating ?? 2)+1 )) {i in
                                    Image(systemName: "star.fill")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                        .foregroundColor(.yellow)
                                }
                            }
                            .offset(y: -3)
                            
                            ReviewText(text: rev.review!, spoiler: rev.spoiler)
                        }
                        .padding()
                    }
                    .padding()
                    
                    
                }
            } else {
                Text("This game doesn't have any reviews yet.")
                    .padding(20)
            }
        }
        
        
        
      
        
    }
}

struct GameReviews_Previews: PreviewProvider {
    static var previews: some View {
        GameReviews(reviews: [])
    }
}
