//
//  GameUserActions.swift
//  Gamescg
//
//  Created by Ayaan  on 2022-09-01.
//

import SwiftUI
import Firebase

struct GameUserActions: View {
    
    @State var name: Game
    @EnvironmentObject var UserData: UserData
    @Environment(\.dismiss) var dismiss
    @State var justAdded: Bool = false
    @State var justRemoved: Bool = false
    @State var inFav: Bool
    @State var inBack: Bool
    @State var rating: Int = 0
    @State var includeReview: Bool = false
    @State var newReviewText: String = "Write your review..."
    
    
    var body: some View {
        VStack {
            HStack {
                Text(name.name)
                    .bold()
                    .font(.largeTitle)
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            
            VStack(alignment: .center) {
             
                HStack(spacing: 10) {
                    VStack {
                        
                        if UserData.FavoriteGames.count >= 4 && !UserData.checkGameInArray(id: name.id, array: UserData.FavoriteGames){
                            Button {
                                return
                            } label: {
                                
                                
                                HStack {
                                    ZStack(alignment: .bottomTrailing) {
                                        Image(systemName: "heart.fill")
                                            .resizable()
                                            .foregroundColor(.white)
                                        .frame(width: 25, height: 25, alignment: .leading)
                                        Image(systemName: "minus.circle.fill")
                                            .resizable()
                                            .frame(width: 15, height: 15)
                                            .foregroundColor(.white)
                                            .offset(x: 8, y: 8)
                                    }
                                        
                                    Text("You arleady have 4 games in favorites")
                                        .foregroundColor(.white)
                                        .bold()
                                        .font(.system(size: 10))
                                        .frame(width: 100)
                                }
                                .padding()
                                .background(Color.gray)
                                .cornerRadius(20)
                                
                                
                            }
                        } else {
                            
                            
                            if !inFav {
                                withAnimation(.linear) {
                                    Button {
                                        UserData.addGameToFavorites(gameId: name.id)
                                        let uid = Auth.auth().currentUser?.uid ?? "no user"
                                        UserData.initUser(uid: uid)
                                        inFav = true
                                    } label: {
                                        
                                        
                                        HStack {
                                            ZStack(alignment: .bottomTrailing) {
                                                Image(systemName: "heart.fill")
                                                    .resizable()
                                                    .foregroundColor(.white)
                                                .frame(width: 25, height: 25, alignment: .leading)
                                                Image(systemName: "plus.circle.fill")
                                                    .resizable()
                                                    .frame(width: 15, height: 15)
                                                    .foregroundColor(.green)
                                                    .offset(x: 8, y: 8)
                                            }
                                                
                                            Text("Favorites")
                                                .foregroundColor(.white)
                                                .bold()
                                                .font(.system(size: 16))
                                                .frame(width: 100)
                                        }
                                        .padding()
                                        .background(Color.blue)
                                        .cornerRadius(20)
                                        
                                        
                                    }
                    
                                }
                                
                            } else {
                                withAnimation(.linear) {
                                    Button {
                                        if UserData.FavoriteGames.count == 1 {
                                            DispatchQueue.main.async {
                                                UserData.FavoriteGames.removeAll()
                                            }
                                        }
                                        UserData.removeGameFromFavorites(gameId: name.id)
                                        let uid = Auth.auth().currentUser?.uid ?? "no user"
                                        UserData.getFavoriteGames(uid: uid)
                                        
                                        inFav = false
                                    } label: {
                                        HStack {
                                            ZStack(alignment: .bottomTrailing) {
                                                Image(systemName: "heart.slash")
                                                    .resizable()
                                                    .foregroundColor(.white)
                                                .frame(width: 25, height: 25, alignment: .leading)
                                                Image(systemName: "minus.circle.fill")
                                                    .resizable()
                                                    .frame(width: 15, height: 15)
                                                    .foregroundColor(.white)
                                                    .offset(x: 8, y: 8)
                                            }
                                            Text("Favorites")
                                                .foregroundColor(.white)
                                                .bold()
                                                .font(.system(size: 16))
                                                .frame(width: 100)
                                        }
                                        .padding()
                                        .background(Color.red)
                                        .cornerRadius(20)
                                        
                                    }
                                }
                            }
                        }
                    }
                        
                        if inBack {
                            Button {
                                if UserData.BacklogGames.count == 1 {
                                    DispatchQueue.main.async {
                                        UserData.BacklogGames.removeAll()
                                    }
                                    
                                }
                                
                                UserData.removeGameFromBacklog(gameId: name.id)
                                let uid = Auth.auth().currentUser?.uid ?? "no user"
                                UserData.getBacklogGames(uid: uid)
                                
                                inBack = false
                            } label: {
                                HStack {
                                    ZStack(alignment: .bottomTrailing) {
                                        Image(systemName: "clock.fill")
                                            .resizable()
                                            .foregroundColor(.white)
                                        .frame(width: 25, height: 25, alignment: .leading)
                                        Image(systemName: "minus.circle.fill")
                                            .resizable()
                                            .frame(width: 15, height: 15)
                                            .foregroundColor(.white)
                                            .offset(x: 8, y: 8)
                                    }
                                    Text("Backlog")
                                        .foregroundColor(.white)
                                        .bold()
                                        .font(.system(size: 16))
                                        .frame(width: 100)
                                }
                                .padding()
                                .background(Color.red)
                                .cornerRadius(20)
                                
                            }
                            
                        } else {
                            Button {
                                UserData.addGameToBacklog(gameId: name.id)
                                let uid = Auth.auth().currentUser?.uid ?? "no user"
                                UserData.initUser(uid: uid)
                                inBack = true
                            } label: {
                                
                                
                                HStack {
                                    ZStack(alignment: .bottomTrailing) {
                                        Image(systemName: "clock.fill")
                                            .resizable()
                                            .foregroundColor(.white)
                                        .frame(width: 25, height: 25, alignment: .leading)
                                        Image(systemName: "plus.circle.fill")
                                            .resizable()
                                            .frame(width: 15, height: 15)
                                            .foregroundColor(.green)
                                            .offset(x: 8, y: 8)
                                    }
                                    Text("Backlog")
                                        .foregroundColor(.white)
                                        .bold()
                                        .font(.system(size: 16))
                                        .frame(width: 100)
                                }
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(20)
                                
                                
                            }
                            
                        }
                        
                        
                        
                        
                        
                    }
                    .padding(30)
                    
                    
                }
            
                Divider()
                .frame(height: 5)
            Text("Rate and Review")
                .bold()
                .font(.title2)
                .frame(alignment: .leading)
                .padding()
            
            StarRating(rating: $rating , disabled: UserData.getRatingOfGame(id: name.id) != 0 , maximumRating: 10)
                .padding()
                .onAppear {
                    rating = UserData.getRatingOfGame(id: name.id  )
                }
            
            Toggle(isOn: $includeReview) {
                Text("Include a review?")
            }
            .onTapGesture {
                includeReview.toggle()
            }
            .padding(.horizontal, 40)
            
            if includeReview {
                TextEditor(text: $newReviewText)
                    .padding()
                    .background(Color.secondary.opacity(0.2))
                    .cornerRadius(10)
                    .frame(width: 300, height: 200)
        
                    .cornerRadius(10)
                    .padding()
                    .onAppear {
                        UITextView.appearance().backgroundColor = .clear
                    }
                    .onTapGesture {
                        newReviewText = ""
                    }
                
            }
                
            
            
            Button {
                // submit rating
                return
            } label: {
                Text("Submit")
                    .bold()
                    .padding()
                    .background(.blue)
                    .buttonStyle(.plain)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .padding(.top, 5)
                    
                    
            }
                
                
                
                
                
                Spacer()
                
                
            }
        }
    }
    
    struct GameUserActions_Previews: PreviewProvider {
        static var previews: some View {
            GameUserActions(name: Gamescg.Game(id: 1877, name: "Cyberpunk 2077", cover: Gamescg.Game.Cover(id: 209384, image_id: "co4hk8"), summary: "Cyberpunk 2077 is an open-world, action-adventure story set in Night City, a megalopolis obsessed with power, glamour and body modification. You play as V, a mercenary outlaw going after a one-of-a-kind implant that is the key to immortality. You can customize your character’s cyberware, skillset and playstyle, and explore a vast city where the choices you make shape the story and the world around you.", involved_companies: [Gamescg.Game.Object(company: Gamescg.Game.Company(id: 774, name: "QLOC"), id: 93176), Gamescg.Game.Object(company: Gamescg.Game.Company(id: 6580, name: "Digital Scapes Studios"), id: 113775), Gamescg.Game.Object(company: Gamescg.Game.Company(id: 19166, name: "CD Projekt Red Wrocław"), id: 113776), Gamescg.Game.Object(company: Gamescg.Game.Company(id: 908, name: "CD Projekt RED"), id: 113777)], screenshots: [Gamescg.Game.Screenshot(id: 214060, image_id: "quphnww1axg2mmsvxfux"), Gamescg.Game.Screenshot(id: 214061, image_id: "jmi4y3q12o4uitdcaf7i"), Gamescg.Game.Screenshot(id: 214062, image_id: "c6ruovzsugjlnlcmm8b0"), Gamescg.Game.Screenshot(id: 214063, image_id: "ydyq0pixly7vt29fnzci"), Gamescg.Game.Screenshot(id: 214064, image_id: "lelfskpwy4slftl3qdeb"), Gamescg.Game.Screenshot(id: 214066, image_id: "c7usjg7gpo8rs0bfjkph"), Gamescg.Game.Screenshot(id: 214067, image_id: "ybliaszwqkwui7djaou4"), Gamescg.Game.Screenshot(id: 214068, image_id: "ts8wtae3t6aghttvtt2s"), Gamescg.Game.Screenshot(id: 214069, image_id: "vnv5cd9kvonsjvazpotx"), Gamescg.Game.Screenshot(id: 214070, image_id: "w4plqrhe04byymfksmux"), Gamescg.Game.Screenshot(id: 214071, image_id: "ubbe5gewccx5ig3xy30t")], platforms: [Gamescg.Game.Platform(id: 6, abbreviation: "PC"), Gamescg.Game.Platform(id: 48, abbreviation: "PS4"), Gamescg.Game.Platform(id: 49, abbreviation: "XONE"), Gamescg.Game.Platform(id: 167, abbreviation: "PS5"), Gamescg.Game.Platform(id: 169, abbreviation: "Series X"), Gamescg.Game.Platform(id: 170, abbreviation: "Stadia")], genres: [Gamescg.Game.Genre(id: 12, name: "Role-playing (RPG)")], first_release_date: 1607472000), inFav: false, inBack: false)
                .environmentObject(UserData())
        }
    }
    
