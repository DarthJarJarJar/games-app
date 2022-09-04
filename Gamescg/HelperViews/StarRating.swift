//
//  StarRating.swift
//  Gamescg
//
//  Created by Ayaan on 2022-09-04.
//

import SwiftUI

struct StarRating: View {
    @Binding var rating: Int

    var label = ""

    var maximumRating = 5

    var offImage: Image?
    var onImage = Image(systemName: "star.fill")

    var offColor = Color.gray
    var onColor = Color.yellow
    
    func image(for number: Int) -> Image {
        if number > rating {
            return offImage ?? onImage
        } else {
            return onImage
        }
    }
    
    
    var body: some View {
        HStack(spacing: 2) {
            

            ForEach(1..<maximumRating + 1, id: \.self) { number in
                image(for: number)
                    .resizable()
                    .foregroundColor(number > rating ? offColor : onColor)
                    .frame(width: 30, height: 30)
                    .onTapGesture {
                        rating = number
                    }
            }
            
            if label.isEmpty == false {
                Text(label)
                    .font(.body)
                    .foregroundColor(.gray)
                    .bold()
                    .padding()
            }
        }
    }
}

struct StarRating_Previews: PreviewProvider {
    static var previews: some View {
        StarRating(rating: .constant(4))
    }
}
