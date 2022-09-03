//
//  Games.swift
//  Gamescg
//
//  Created by Ayaan  on 2022-08-31.
//

import SwiftUI

struct Games: View {
    @State var Ratings: [Dictionary<String, Int>]
    @State var RatedGames: [Game]
    var threeColumnGrid = [GridItem(.flexible()), GridItem(.flexible())]
    func getRatingOfGame(id: Int, ratings: [Dictionary<String, Int>]) -> Int {
        var final: Int = 0
        for rating in ratings {
            if rating["id"] == id {
                final = rating["rating"] ?? 0
            }
        }
        return final
    }
    var body: some View {
        
        
        
      
            
            ScrollView {
                withAnimation(.easeOut) {
                    LazyVGrid(columns: threeColumnGrid){
                        ForEach(RatedGames) { game in
                            
                            withAnimation(.linear) {
                                NavigationLink {
                                    withAnimation(.spring()) {
                                        GameProto(id: game.id)
                                    }
                                    
                                } label: {
                                    RatedGameCover(width: 150, image_id: game.cover.image_id, rating: getRatingOfGame(id: game.id, ratings: Ratings))
                                    
                                }
                            }
                        }
                        
                        .padding()
                    } .padding()
                }
            }
            .navigationTitle("Games")
            
            
        

    }
}


