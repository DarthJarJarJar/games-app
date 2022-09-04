//
//  ReviewText.swift
//  Gamescg
//
//  Created by Ayaan  on 2022-09-01.
//

import SwiftUI

struct ReviewText: View {
    @State var text: String
    @State var spoiler: Bool
    @State var showSpoiler: Bool = false
    var body: some View {
        ZStack(alignment: .leading) {
            if spoiler {
                withAnimation(.easeInOut(duration: 0.1)) {
                RoundedRectangle(cornerRadius: 3)
                        .foregroundColor(.gray)
                    .opacity(showSpoiler ? 0.3 : 1.0)
                    .onTapGesture{
                        showSpoiler.toggle()
                    }
                }
                
                HStack(alignment: .center) {
                    Image(systemName: "eye.fill")
                        .foregroundColor(.white)
                    Text("This review contains spoilers. Click to reveal.")
                        .bold()
                        .font(.caption)
                        .foregroundColor(.white)
                }
                .padding()
                .foregroundColor(.gray)
                .opacity(showSpoiler ? 0.0 : 1.0)
                   
                    
                Text(text)
                    .padding()
                    .opacity(showSpoiler ? 1.0 : 0.0)
            } else {
                Text(text)
                    .padding( .top, 2 )
            }
            
                
        }
    }
}

struct ReviewText_Previews: PreviewProvider {
    static var previews: some View {
        ReviewText(text: "this is a review", spoiler: true)
    }
}
