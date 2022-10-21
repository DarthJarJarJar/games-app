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
    @EnvironmentObject var UserData: UserData
    private var threeColumnGrid = [GridItem(.flexible()), GridItem(.flexible())]
    @State private var showSheet = false
    @State var uid = "no user"
    
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
                                    
                                    if UserData.isLoggedIn {
                                        
                                        
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
            UserData.getUserName(uid: uid)
            network.getUsers()
        }
        
        
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
            .environmentObject(Network())
            .environmentObject(UserData())
            .previewDevice("iPhone 13")
    }
}
