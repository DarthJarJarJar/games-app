//
//  UserReviewView.swift
//  Gamescg
//
//  Created by Ayaan  on 2022-08-31.
//

import SwiftUI



struct UserReviewView: View {
    @EnvironmentObject var UserData: UserData
    @State var showSpoiler: Bool = false
    var body: some View {
        ScrollView {
            ForEach(UserData.Reviews) { rev in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 0.5)
                        .foregroundColor(.white)
                    
                    
                    VStack(alignment: .leading) {
                        Text(rev.gameName ?? "nO name")
                            .font(.title3)
                            .bold()
                        HStack(spacing: 2) {
                            ForEach(1..<((rev.rating ?? 2)+1 ?? 2)) {i in
                                Image(systemName: "star.fill")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                                    .foregroundColor(.yellow)
                            }
                        }
                        .offset(y: -3)
                        
                        ReviewText(text: rev.review!, spoiler: rev.spoiler)
                    }
                    .padding()
                }
                .padding()
                
                
            }
        }
        
        
        .navigationTitle("Reviews")
        
        
        .onAppear {
            UserData.getReviews()
        }
        
        
    }
    
}


struct UserReviewView_Previews: PreviewProvider {
    static var previews: some View {
        UserReviewView()
            .environmentObject(UserData())
    }
}
