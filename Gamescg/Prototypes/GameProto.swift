//
//  GameById.swift
//  Gamescg
//
//  Created by Ayaan  on 2022-08-27.
//

import SwiftUI
import WrappingHStack
import FirebaseFirestore


struct GameProto: View {
    @EnvironmentObject var UserData: UserData
    @State var id: Int
    @State var game: [Game] = []
    @State var reviews: [Review] = []
    @State private var showSheet = false
    
    
    
    func getReviewsOfGame() {
        var dictHolder: [Dictionary<String, Any>] = []
        var reviews: [Review] = []
        let db = Firestore.firestore()
        db.collection("games").whereField("gameId", isEqualTo: id)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        dictHolder.append(document.data())
                        
                    }
                }
                
                for review in dictHolder {
                    if review["review"] as! String != "" {
                    reviews.append(Review(gameId: review["gameId"] as? Int, gameName: review["gameName"] as? String, rating: review["rating"] as? Int, review: review["review"] as? String, reviewAt: review["reviewAt"] as! Int, reviewBy: review["reviewBy"] as? String, reviewerName: review["reviewerName"] as? String, spoiler: review["spoiler"] as! Bool))
                    }
                    }
                print("added data")
                print(reviews)
                self.reviews = reviews
    
            }
            
        
    }
    
    func getGameById() {
        guard let url = URL(string: "https://api.igdb.com/v4/games/") else { fatalError("Missing URL") }
        
        var requestHeader = URLRequest.init(url: url )
        requestHeader.httpBody = "fields name, involved_companies.company.name, genres.name, first_release_date, screenshots.image_id, cover.image_id, platforms.abbreviation, summary; sort follows desc; where rating != null & follows != null & id = \(id);".data(using: .utf8, allowLossyConversion: false)
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
    var threeColumnGrid = [GridItem(.adaptive(minimum: 200, maximum: 210)), GridItem(.adaptive(minimum: 200, maximum: 210)),GridItem(.adaptive(minimum: 200, maximum: 210))]
    @Namespace var namespace
    var body: some View {
        
        ScrollView {
            if !game.isEmpty {
                ForEach(game) { game in
                    withAnimation(.easeInOut) {
                        VStack {
                            ZStack(alignment: .bottom) {
                                GameDetailPosterImage(imageId: game.cover.image_id)
                                
                                
                            }
                            withAnimation(.default) {
                                VStack {
                                 

                                    GameTitleView(game: game, signedIn: UserData.isLoggedIn, inFav: UserData.checkGameInArray(id: game.id, array: UserData.FavoriteGames), inBack: UserData.checkGameInArray(id: game.id, array: UserData.BacklogGames))
                                        
                                        Text(game.summary)
                                        .padding(20)
                                        .padding(.top, 0)
                                    Spacer()
                                    
                                    Text("Screenshots")
                                        .bold()
                                        .font(.title2)
                                        .frame(alignment: .leading)
                                    
                                    Screenshots(screenshots: game.screenshots)
                                    Spacer()
                                    
                                    WrappingHStack(game.platforms) { platform in
                                        
                                        Text(platform.abbreviation)
                                            .bold()
                                            .foregroundColor(.white)
                                            .font(.caption)
                                            .padding()
                                            .background(.blue)
                                            .cornerRadius(20.0)
                                            .padding(1)
                                            .padding(.bottom, 8)
                                        
                                        
                                    }
                                    
                                    .padding(8)
                                    
                                    
                                    WrappingHStack(game.genres) { genre in
                                        
                                        Text(genre.name)
                                            .bold()
                                            .foregroundColor(.white)
                                            .font(.caption)
                                            .padding()
                                            .background(.red)
                                            .cornerRadius(20.0)
                                            .padding(1)
                                            .padding(.bottom, 8)
                                        
                                        
                                    }
                                    
                                    .padding(8)
                                    
                                    if UserData.isLoggedIn {
                                        ForEach(reviews) { review in
                                            Text(review.review ?? "nothing")
                                        }
                                    }
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                }
                                
                                .offset(y: -200)
                                .animation(.spring(response: 1, dampingFraction: 1))
                            }
                            
                        }
                        
                        .navigationTitle(game.name)
                        .navigationBarTitleDisplayMode(.inline)
                    }
                    
                    
                }
                
                
            } else {
                
                VStack {
                    ProgressView()
                        .padding(400)
                }
                
            }
            
        }
        .onAppear {
            getGameById()
            getReviewsOfGame()
        }
        
    }
}




struct GameProto_Previews: PreviewProvider {
    static var previews: some View {
        GameProto(id: 119133)
            .environmentObject(UserData())
            .previewDevice("iPhone 13 Pro Max")
    }
}
