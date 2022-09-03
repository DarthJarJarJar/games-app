//
//  Search.swift
//  Gamescg
//
//  Created by Ayaan  on 2022-08-29.
//

import SwiftUI

struct Search: View {
    
    @State var searchText: String = ""
    
    @State var games: [SearchedGame] = []
    
    func search(key: String) {
        guard let url = URL(string: "https://api.igdb.com/v4/games/") else { fatalError("Missing URL") }
        
        var requestHeader = URLRequest.init(url: url )
        requestHeader.httpBody = "search \"\(key)\"; fields name, cover.image_id;".data(using: .utf8, allowLossyConversion: false)
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
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
        }
        
        dataTask.resume()
    }

    var body: some View {
        NavigationView {
            NavigationLink{
                SearchSearch(key: searchText)
            } label: {
                Text(" Search for \(searchText)")
                    .navigationTitle("Search")
                    .searchable(text: $searchText)
                    
            }
            
        }
       
        
        
    }
}

struct Search_Previews: PreviewProvider {
    static var previews: some View {
        Search()
    }
}
