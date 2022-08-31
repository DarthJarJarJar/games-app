//
//  ModalTest.swift
//  Gamescg
//
//  Created by Ayaan  on 2022-08-30.
//

import SwiftUI

struct ModalTest: View {
   @State private var showSheet = false

   var body: some View {
       Button("Present") {
           showSheet.toggle()
       }.font(.largeTitle)
       .sheet(isPresented: $showSheet) {
           GameProto(id: 119133)
       }
    }
}

struct SheetView: View {
   @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
           Button {
              dismiss()
           } label: {
               Image(systemName: "xmark.circle")
                 .font(.largeTitle)
                 .foregroundColor(.gray)
           }
         }
       
         .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
         .padding()
    }
}

struct ModalTest_Previews: PreviewProvider {
    static var previews: some View {
        ModalTest()
    }
}
