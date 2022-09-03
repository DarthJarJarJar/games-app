//
//  GameById.swift
//  Gamescg
//
//  Created by Ayaan  on 2022-08-27.
//

import SwiftUI

struct GameById: View {
    @EnvironmentObject var network: Network
    @State var id: Int
    @State var game: [Game] = []
    func getGameById() {
        guard let url = URL(string: "https://api.igdb.com/v4/games/") else { fatalError("Missing URL") }

        var requestHeader = URLRequest.init(url: url )
        requestHeader.httpBody = "fields name, involved_companies.company.name, screenshots.image_id, cover.image_id, summary; sort follows desc; where rating != null & follows != null & id = \(id);".data(using: .utf8, allowLossyConversion: false)
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
                        let decodedUsers = try JSONDecoder().decode([Game].self, from: data)
                        self.game = decodedUsers
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
        }

        dataTask.resume()
    }
    var body: some View {
        
        VStack(spacing: 0) {
            ForEach(game) {game in
                ScrollView{
                    VStack(alignment: .leading){
                        ScrollView(.horizontal) {
                            HStack{
                            ForEach(game.screenshots) {
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
                        
                    
                        VStack(alignment: .leading) {
                    ForEach(game.involved_companies) {company in
                        Text(company.company.name)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .bold()
            
                    }
                    }
                    
                    Text(game.summary)
                            .padding(.top)
                        
                }
                .frame( alignment: .top)
                .padding(30)
                }
                .navigationTitle(game.name)
                .navigationBarTitleDisplayMode(.inline)
                
            }
        }
        .onAppear {
            getGameById()
        }
        
    }
}

struct GameById_Previews: PreviewProvider {
    static var previews: some View {
        GameById(id: 119133)
            .environmentObject(Network())
            .previewDevice("iPhone 13 Pro")
    }
}
