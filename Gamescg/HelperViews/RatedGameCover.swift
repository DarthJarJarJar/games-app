//
//  RatedGameCover.swift
//  Gamescg
//
//  Created by Ayaan  on 2022-08-31.
//

import SwiftUI

struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}

struct RatedGameCover: View {
    @State var width: CGFloat
    @State var image_id: String
    @State var rating: Int
    var body: some View {
        ZStack(alignment: .bottomTrailing)
               {
            CoverHScrollImage(width: width, imageId: image_id)
            ZStack {
                VisualEffectView(effect: UIBlurEffect(style: .light))
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: 30, height: 30)
                    .cornerRadius(5)
                HStack(spacing: 4) {
                    Text(String(rating))
                        .font(.caption)
                        .bold()
                    .foregroundColor(.black)
                    Image(systemName: "star.fill")
                        .resizable()
                        .foregroundColor(.black)
                        .offset(y: -0.5)
                        .frame(width: 10, height: 10)
                }
                
            }
            .offset(x: -4, y: -4)
            
        }
    }
    
    struct RatedGameCover_Previews: PreviewProvider {
        static var previews: some View {
            RatedGameCover(width: 100, image_id: "co4jni", rating: 9)
        }
    }
}
