//
//  GameTitleView.swift
//  Gamescg
//
//  Created by Ayaan  on 2022-09-02.
//

import SwiftUI

struct GameTitleView: View {
    @State var game: Game
    @State var signedIn: Bool
    @State var inFav: Bool
    @State var inBack: Bool
    @State private var show = false
    var body: some View {
        VStack {
        Text(game.name)
            .bold()
            .animation(.easeInOut)
            .font(.largeTitle)
            .offset(x: 0, y: -20)
            .padding()
        
        if signedIn {
            
            Image(systemName: "plus.circle.fill")
                .resizable()
                .foregroundColor(.green)
                .frame(width: 40, height: 40)
                .offset(x: 0, y: -20)
                .onTapGesture {
                    show.toggle()
                }
                .sheet(isPresented: $show) {
                    GameUserActions(name: game, inFav: inFav, inBack: inBack)
                       }
        }
        
        CompaniesList(companies: game.involved_companies)
    }
    }
}

