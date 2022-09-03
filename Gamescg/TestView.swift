//
//  TestView.swift
//  Gamescg
//
//  Created by Ayaan  on 2022-08-31.
//

import SwiftUI

struct TestView: View {
    @EnvironmentObject var UserData: UserData
    
    var body: some View {
        if UserData.isLoggedIn{
            Text("Yes")
        } else {
            Text("No")
        }
        
        
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
            .environmentObject(UserData())
    }
}
