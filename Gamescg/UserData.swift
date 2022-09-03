//
//  UserData.swift
//  Gamescg
//
//  Created by Ayaan  on 2022-08-31.
//

import Foundation
import Firebase
import FirebaseFirestore

class UserData: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var FavoriteGames: [Game] = []
    @Published var BacklogGames: [Game] = []
    @Published var RatedGames: [Game] = []
    @Published var Ratings: [Dictionary<String, Int>] = []
    @Published var UserReviews: [Dictionary<String, Any>] = []
    @Published var Username: String = ""
    @Published var Reviews: [Review] = []
    let db = Firestore.firestore()
    
    
    

    var isSignedIn: Bool {
        return Auth.auth().currentUser != nil
    }
    
    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [self] (result, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                self.isLoggedIn = true
                let uid: String = Auth.auth().currentUser?.uid ?? "no user"
                self.getFavoriteGames(uid: uid)
                self.initUser(uid: uid)
                print("success")
            }
        }
        
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            isLoggedIn = false
            clearUserData()
        } catch {
            print("error")
        }
    }
    
    func formatArrayForQuery(array: [Int]) -> String {
        var string = "("
        for int in array {
            string += "\(String(int)),"
        }
        string.remove(at: string.index(before: string.endIndex))
        
        string += ")"
        return string
    }
    
    
    func initUser(uid: String) {
        DispatchQueue.main.async {
            self.getFavoriteGames(uid: uid)
            self.getBacklogGames(uid: uid)
            self.getRatedGames(uid: uid)
            self.getUserName(uid: uid)
            self.getReviews()
        }
        
        
        
        
    }
    
    func clearUserData() {
        self.BacklogGames = []
        self.FavoriteGames = []
        self.RatedGames = []
        self.Reviews.removeAll()
    }
    
    func getQueryStringForRatingIds(ratings: [Dictionary<String, Int>]) -> String {
        var arrayOfRatings: [Int] = []
        for rating in ratings {
            arrayOfRatings.append(rating["id"] ?? 0)
        }
        let string = formatArrayForQuery(array: arrayOfRatings)
        return string
    }
    
    func getRatingOfGame(id: Int) -> Int {
        var final: Int = 0
        for rating in self.Ratings {
            if rating["id"] == id {
                final = rating["rating"] ?? 0
            }
        }
        return final
    }
    
    func getUserName(uid: String) {
        db.collection("users").whereField("uid", isEqualTo: uid)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        self.Username = document.data()["displayName"] as! String
                        
                    }
                }
            }
    }
    
    func checkGameInArray(id: Int, array: [Game]) -> Bool {
        var isPresent: Bool = false
        for game in array {
            if id == game.id {
                isPresent = true
                break
            }
        }
        return isPresent
    }
    
    func addGameToFavorites(gameId: Int) {
        db.collection("users").whereField("displayName", isEqualTo: self.Username)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let docId = document.documentID
                        let ref = self.db.collection("users").document(docId)

                        
                        ref.updateData([
                            "favourites": FieldValue.arrayUnion([gameId])
                        ])
                        print("added")
                        
                    }
                }
            }
    }
    
    func removeGameFromFavorites(gameId: Int) {
        db.collection("users").whereField("displayName", isEqualTo: self.Username)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let docId = document.documentID
                        let ref = self.db.collection("users").document(docId)

                        
                        ref.updateData([
                            "favourites": FieldValue.arrayRemove([gameId])
                        ])
                        print("removed")
                        
                    }
                }
            }
    }
    
    
    func addGameToBacklog(gameId: Int) {
        db.collection("users").whereField("displayName", isEqualTo: self.Username)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let docId = document.documentID
                        let ref = self.db.collection("users").document(docId)

                        
                        ref.updateData([
                            "backlog": FieldValue.arrayUnion([gameId])
                        ])
                        print("added")
                        
                    }
                }
            }
    }
    
    func removeGameFromBacklog(gameId: Int) {
        db.collection("users").whereField("displayName", isEqualTo: self.Username)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let docId = document.documentID
                        let ref = self.db.collection("users").document(docId)

                        
                        ref.updateData([
                            "backlog": FieldValue.arrayRemove([gameId])
                        ])
                        print("removed")
                        
                    }
                }
            }
    }
    
    
    
    func getReviews() {
        
        print("--------")
        print("inside function")
        print("initial count \(self.Reviews.count). Clearing....")
        self.UserReviews.removeAll()

        self.Reviews.removeAll()
        print("count after clearing -> \(self.Reviews.count)")
        db.collection("games").whereField("reviewBy", isEqualTo: Username)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        self.UserReviews.append(document.data())
                        
                    }
                }
                self.Reviews.removeAll()
                for review in self.UserReviews {
                    if review["review"] as! String != "" {
                    self.Reviews.append(Review(gameId: review["gameId"] as? Int, gameName: review["gameName"] as? String, rating: review["rating"] as? Int, review: review["review"] as? String, reviewAt: review["reviewAt"] as! Int, reviewBy: review["reviewBy"] as? String, reviewerName: review["reviewerName"] as? String, spoiler: review["spoiler"] as! Bool))
                    }
                    }
                print("added data. new count -> \(self.Reviews.count)")
    
            }
        
    }
    
   
    
    
    func getRatedGames(uid: String) {
        
        db.collection("users").whereField("uid", isEqualTo: uid)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let ratingObjectArray: [Dictionary<String, Int>]  = document.data()["ratings"] as! [Dictionary<String, Int>]
                        self.Ratings = ratingObjectArray
                        let queryString = self.getQueryStringForRatingIds(ratings: ratingObjectArray)
                        
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
                                        self.RatedGames = decodedUsers
                                    } catch let error {
                                        print("Error decoding: ", error)
                                    }
                                }
                            }
                        }
                        
                        dataTask.resume()
                        
                    }
                }
            }
        
        
    }
    
    func getFavoriteGames(uid: String) {
        
        db.collection("users").whereField("uid", isEqualTo: uid)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let favoriteIds: [Int]  = document.data()["favourites"] as! [Int]
                        let queryString = self.formatArrayForQuery(array: favoriteIds)
                        
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
                                    } catch let error {
                                        print("Error decoding: ", error)
                                    }
                                }
                            }
                        }
                        
                        dataTask.resume()
                        
                    }
                }
            }
        
        
    }
    
    func getBacklogGames(uid: String) {
        
      
        db.collection("users").whereField("uid", isEqualTo: uid)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let backlogIds: [Int] = document.data()["backlog"] as! [Int]
                        let queryString = self.formatArrayForQuery(array: backlogIds)
                        
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
                                    } catch let error {
                                        print("Error decoding: ", error)
                                    }
                                }
                            }
                        }
                        
                        dataTask.resume()
                    }
                }
            }
       
        
        
    }
    
    init () {
        if Auth.auth().currentUser?.uid != nil {
            isLoggedIn = true
            getFavoriteGames(uid: Auth.auth().currentUser?.uid ?? "no user")
            getBacklogGames(uid: Auth.auth().currentUser?.uid ?? "no user")
        } else {
            isLoggedIn = false
        }
        
    }
}
