//
//  SearchSearch.swift
//  Gamescg
//
//  Created by Ayaan Shahab on 2022-08-29.
//

import SwiftUI

struct SearchSearch: View {
    @State var key: String
    @State var games: [SearchedGame] = []
    var threeColumnGrid = [GridItem(.flexible()), GridItem(.flexible())]
    
    func search() {
        guard let url = URL(string: "https://api.igdb.com/v4/games/") else { fatalError("Missing URL") }
        
        var requestHeader = URLRequest.init(url: url )
        requestHeader.httpBody = "search \"\(key)\"; fields name, cover.image_id; where cover.image_id != null & version_parent = null & screenshots != null;".data(using: .utf8, allowLossyConversion: false)
        requestHeader.httpMethod = "POST"
        requestHeader.setValue("o5xvtlqq670n8hhzz05rvwpbr7hjt4", forHTTPHeaderField: "Client-ID")
        requestHeader.setValue("Bearer eusymeo73nswru9jiajpm2oij93hdb", forHTTPHeaderField: "Authorization")
        requestHeader.setValue("application/json", forHTTPHeaderField: "Accept")
        
        
        let dataTask = URLSession.shared.dataTask(with: requestHeader) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }
            guard let response = response as? HTTPURLResponse else { return }
            
            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        let decodedUsers = try JSONDecoder().decode([SearchedGame].self, from: data)
                        self.games = decodedUsers
                        print(decodedUsers)
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
        }
        
        dataTask.resume()
    }
    var body: some View {
        
        ScrollView {
            LazyVGrid(columns: threeColumnGrid){
                ForEach(games) { game in
                    
                    NavigationLink {
                        GameProto(id: game.id)
                    } label: {
                        CoverImage(imageId: game.cover.image_id)
                    }
                }
                .navigationTitle("Search Results")
                .padding()}
            
            
        }
        
        
        .onAppear {
            search()
        }
    }
}

struct SearchSearch_Previews: PreviewProvider {
    static var previews: some View {
        SearchSearch(key: "mgs")
    }
}
