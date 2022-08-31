//
//  HomePage.swift
//  Gamescg
//
//  Created by Ayaan  on 2022-08-29.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct HomePage: View {
    @EnvironmentObject var network: Network
    private var threeColumnGrid = [GridItem(.flexible()), GridItem(.flexible())]
    @State var fontSize: Int = 0
    @State var bold: Bool = false
    @State var italic: Bool = false
    @State private var showSheet = false
    @State var uid = "no user"
    @State var username = ""
    let db = Firestore.firestore()
    
    var body: some View {
        
        
        
        NavigationView {
            
            ScrollView {
                
                
                withAnimation(.easeOut) {
                    LazyVGrid(columns: threeColumnGrid){
                        ForEach(network.users) { user in
                            
                            withAnimation(.linear) {
                                NavigationLink {
                                    withAnimation(.spring()) {
                                        GameProto(id: user.id)
                                    }
                                    
                                } label: {
                                    CoverImage(imageId: user.cover.image_id)
                                    
                                }
                            }
                        }
                        .toolbar {
                            ToolbarItemGroup {
                                
                                HStack(spacing: 8) {
                                    
                                    if username != "" {
                                        Text("Logged in as \(username)")
                                            .bold()
                                        
                                            .font(.subheadline)
                                        
                                        
                                        Image(systemName: "checkmark.seal.fill")
                                            .foregroundColor(.green)
                                        
                                        
                                    } else {
                                        withAnimation(.default) {
                                            Text("Not logged in")
                                                .bold()
                                                
                                                .font(.subheadline)
                                        }
                                        
                                        Image(systemName: "xmark.seal.fill")
                                            .foregroundColor(.red)
                                        
                                    }
                                    
                                    
                                }
                                
                            }
                        }
                        
                        .navigationTitle(" Games")
                        
                        
                        
                        .padding()
                        
                        
                    } .padding()
                }
                
                
            }
            
            
        }
        .onAppear {
            uid = Auth.auth().currentUser?.uid ?? "no user"
            if uid != "no user" {
                db.collection("users").whereField("uid", isEqualTo: uid)
                    .getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for document in querySnapshot!.documents {
                                username = document.data()["displayName"] as! String
                            }
                        }
                    }
            } else {
                username = ""
            }
            network.getUsers()
        }
        
        
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
            .environmentObject(Network())
            .previewDevice("iPhone 13")
    }
}
