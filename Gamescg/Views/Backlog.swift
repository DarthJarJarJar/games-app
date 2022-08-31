//
//  Backlog.swift
//  Gamescg
//
//  Created by Ayaan  on 2022-08-30.
//

import SwiftUI

struct Backlog: View {
    @State var BacklogGames: [Game]
    var threeColumnGrid = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        
        
        
      
            
            ScrollView {
                withAnimation(.easeOut) {
                    LazyVGrid(columns: threeColumnGrid){
                        ForEach(BacklogGames) { user in
                            
                            withAnimation(.linear) {
                                NavigationLink {
                                    withAnimation(.spring()) {
                                        GameProto(id: user.id)
                                    }
                                    
                                } label: {
                                    CoverImage(imageId: user.cover.image_id)
                                    
                                }
                            }
                        }
                        .navigationTitle("Backlog")
                        .padding()
                    } .padding()
                }
            }
            
            
        

    }
}

