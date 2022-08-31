//
//  ContentView.swift
//  Gamescg
//
//  Created by Ayaan Shahab on 2022-08-26.
//

import SwiftUI

struct Proto: View {
    @EnvironmentObject var network: Network
    private var threeColumnGrid = [GridItem(.fixed(150)), GridItem(.fixed(150))]
    @State private var showSheet = false
    
    var body: some View {
        
        NavigationView {
            
            ScrollView {
                LazyVGrid(columns: threeColumnGrid){
                ForEach(network.users) { user in
                
               
                    CoverImage(imageId: user.cover.image_id)
                        .onTapGesture {
                            showSheet.toggle()
                        }
                    
                        .sheet(isPresented: $showSheet) {
                            GameModal()
                               
                        }
                    
                
                
              
            }
            .navigationTitle("Popular Games")
                    .padding()} .padding()
            }
        }
        .onAppear {
            network.getUsers()
        }
    }
}

struct Proto_Previews: PreviewProvider {
    static var previews: some View {
        Proto()
            .environmentObject(Network())
            .previewDevice("iPhone 13")
    }
}
