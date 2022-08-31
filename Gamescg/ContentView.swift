//
//  ContentView.swift
//  Gamescg
//
//  Created by Ayaan  on 2022-08-26.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var network: Network
    private var threeColumnGrid = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        
        
        TabView {
                HomePage()
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                }
                Profile()
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("Profile")
                }
                Search()
                    .tabItem {
                        Image(systemName: "magnifyingglass.circle.fill")
                        Text("Search")
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Network())
            .previewDevice("iPhone 13")
    }
}
