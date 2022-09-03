//
//  Profile.swift
//  Gamescg
//
//  Created by Ayaan  on 2022-08-29.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct Profile: View {
    @EnvironmentObject var UserData: UserData
    @State var currentUser = Auth.auth().currentUser
    @State private var userIsLoggedIn = false
    @State var email = ""
    @State var password = ""
    @State var uid: String = "no user"
   
    private var threeColumnGrid = [GridItem(.fixed(150)), GridItem(.fixed(150))]

    
    var body: some View {
        if UserData.isLoggedIn {
            
            
            
            NavigationView {
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Favorites")
                            .font(.title3)
                            .bold()
                        
                        ScrollView(.horizontal) {
                            LazyVGrid(columns: threeColumnGrid) {
                                if UserData.FavoriteGames.isEmpty {
                                    Text("No games added yet.")
                                } else {
                                ForEach(UserData.FavoriteGames) { game in
                                    NavigationLink {
                                        GameProto(id: game.id)
                                    } label: {
                                        CoverHScrollImage(width: 150, imageId: game.cover.image_id)
                                            .padding()
                                        
                                    }
                                }
                            }
                            }
                            .offset(x: 5)
                            .padding()
                        }
                    }
                    .padding()
                    Divider()
                        .frame(height: 5)
                    
                    
                    VStack(alignment: .leading, spacing: 3) {
                        NavigationLink {
                            Gamescg.Backlog(BacklogGames: UserData.BacklogGames)
                        } label: {
                            HStack(spacing: 10) {
                                Text("Backlog")
                                    .font(.title3)
                                    .bold()
                                Image(systemName: "chevron.forward")
                            }
                            
                            .buttonStyle(.plain)
                        }
                        .buttonStyle(.plain)
                        
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(UserData.BacklogGames) { game in
                                    NavigationLink {
                                        GameProto(id: game.id)
                                    } label: {
                                        CoverHScrollImage(width: 100, imageId: game.cover.image_id)
                                        
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                    .padding()
                    Divider()
                        .frame(height: 5)
                    
                    VStack(alignment: .leading, spacing: 3) {
                        NavigationLink {
                            Gamescg.Games(Ratings: UserData.Ratings, RatedGames: UserData.RatedGames)
                        } label: {
                            HStack(spacing: 10) {
                                Text("Games")
                                    .font(.title3)
                                    .bold()
                                Image(systemName: "chevron.forward")
                            }
                            
                            .buttonStyle(.plain)
                        }
                        .buttonStyle(.plain)
                        
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(UserData.RatedGames) { game in
                                    NavigationLink {
                                        GameProto(id: game.id)
                                    } label: {
                                
                                        RatedGameCover(width: 100, image_id: game.cover.image_id, rating: UserData.getRatingOfGame(id: game.id))
                                        
                                    }
                                }
                            }
                            .onAppear{
                                UserData.getRatedGames(uid: uid)
                            }
                            .padding()
                        }
                    }
                    .padding()
                    Divider()
                        .frame(height: 5)
                    VStack(alignment: .leading, spacing: 3) {
                        NavigationLink {
                            UserReviewView()
                        } label: {
                            HStack(spacing: 10) {
                                Text("Reviews")
                                    .font(.title3)
                                    .bold()
                                Image(systemName: "chevron.forward")
                            }
                            
                            .buttonStyle(.plain)
                        }
                        .buttonStyle(.plain)
                        
                        ScrollView(.horizontal) {
                            HStack {
                                
                            }
                            .padding()
                        }
                    }
                    .padding()
                    Divider()
                        .frame(height: 5)
                    
                    
                }
                
                
                .toolbar {
                    ToolbarItemGroup {
                        Button {
                            UserData.logout()
                        } label: {
                            Image(systemName: "arrow.left.square.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.red)
                            
                        }
                        
                        
                    }
                }
                .navigationTitle("\(UserData.Username)")
                
                .onAppear{
                    uid = Auth.auth().currentUser?.uid ?? "no user"
                    UserData.initUser(uid: uid)
                    UserData.getRatedGames(uid: uid)
                   
                }
            }
            
        } else {
            content
            
        }
    }
    
    
    var content: some View {
        NavigationView {
            
            VStack {
                TextField("Email", text: $email)
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.never)
                SecureField("Password", text: $password)
                Button(action: {
                    UserData.login(email: email, password: password)
                }) {
                    Text("Sign in")
                }
            }
            .padding()
            .navigationTitle("Sign In")
            
            
            
        }
        .onAppear{
            Auth.auth().addStateDidChangeListener { auth, user in
                if user != nil {
                    uid = user?.uid ?? ""
                    userIsLoggedIn = true
                }
            }
        }
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
            .environmentObject(UserData())
    }
}
