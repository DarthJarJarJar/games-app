//
//  Profile.swift
//  Gamescg
//
//  Created by Ayaan Shahab on 2022-08-29.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct Profile: View {
    @State var username: String = ""
    @State var currentUser = Auth.auth().currentUser
    @State private var userIsLoggedIn = false
    @State var email = ""
    @State var password = ""
    @State var uid: String = "no user"
    @State var Favorites: [Int] = []
    @State var FavoriteGames: [Game] = []
    @State var FavString: String = ""
    @State var Backlog: [Int] = []
    @State var BacklogStr: String = ""
    @State var BacklogGames: [Game] = []
    private var threeColumnGrid = [GridItem(.fixed(150)), GridItem(.fixed(150))]
    
    let db = Firestore.firestore()
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                print("success")
            }
        }
        
    }
    
    func getGameById(queryString: String) {
        guard let url = URL(string: "https://api.igdb.com/v4/games/") else { fatalError("Missing URL") }
        
        var requestHeader = URLRequest.init(url: url )
        requestHeader.httpBody = "fields name, involved_companies.company.name, genres.name, first_release_date, screenshots.image_id, cover.image_id, platforms.abbreviation, summary; sort follows desc; where rating != null & follows != null & id = \(queryString);".data(using: .utf8, allowLossyConversion: false)
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
                        self.FavoriteGames = decodedUsers
                        print(decodedUsers)
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
        }
        
        dataTask.resume()
    }
    func getBacklog(queryString: String) {
        guard let url = URL(string: "https://api.igdb.com/v4/games/") else { fatalError("Missing URL") }
        
        var requestHeader = URLRequest.init(url: url )
        requestHeader.httpBody = "fields name, involved_companies.company.name, genres.name, first_release_date, screenshots.image_id, cover.image_id, platforms.abbreviation, summary; sort follows desc; where rating != null & follows != null & id = \(queryString);".data(using: .utf8, allowLossyConversion: false)
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
                        self.BacklogGames = decodedUsers
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
        if userIsLoggedIn {
            
            
            
            NavigationView {
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Favorites")
                            .font(.title3)
                            .bold()
                       
                        ScrollView(.horizontal) {
                            LazyVGrid(columns: threeColumnGrid) {
                                ForEach(FavoriteGames) { game in
                                    NavigationLink {
                                        GameProto(id: game.id)
                                    } label: {
                                        CoverHScrollImage(width: 150, imageId: game.cover.image_id)
                                            .padding()
                                        
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
                            Gamescg.Backlog(BacklogGames: BacklogGames)
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
                                ForEach(BacklogGames) { game in
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
                    
                    
                }
                
                
                .toolbar {
                    ToolbarItemGroup {
                        Button {
                            do {
                                try Auth.auth().signOut()
                                userIsLoggedIn = false
                                Backlog = []
                                BacklogGames = []
                                BacklogStr = ""
                                Favorites = []
                                FavoriteGames = []
                                FavString = ""
                            } catch {
                                print("error")
                            }
                        } label: {
                            Image(systemName: "arrow.left.square.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.red)
                            
                        }
                        
                        
                    }
                }
                .navigationTitle("\(username)")
                
                .onAppear{
                    uid = Auth.auth().currentUser?.uid ?? "no user"
                    print(uid)
                    if uid != "no user" {
                        db.collection("users").whereField("uid", isEqualTo: uid)
                            .getDocuments() { (querySnapshot, err) in
                                if let err = err {
                                    print("Error getting documents: \(err)")
                                } else {
                                    for document in querySnapshot!.documents {
                                        username = document.data()["displayName"] as! String
                                        print(username)
                                        Favorites = document.data()["favourites"] as! [Int]
                                        FavString += "("
                                        for int in Favorites {
                                            FavString+="\(String(int)),"
                                        }
                                        FavString.remove(at: FavString.index(before: FavString.endIndex))
                                        
                                        FavString += ")"
                                        
                                        Backlog = document.data()["backlog"] as! [Int]
                                        BacklogStr += "("
                                        for int in Backlog {
                                            BacklogStr+="\(String(int)),"
                                        }
                                        BacklogStr.remove(at: BacklogStr.index(before: BacklogStr.endIndex))
                                        
                                        BacklogStr += ")"
                                    }
                                    getGameById(queryString: FavString)
                                    getBacklog(queryString: BacklogStr)
                                    print(FavString)
                                }
                            }
                    } else {
                        username = ""
                    }
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
                    login()
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
    }
}
