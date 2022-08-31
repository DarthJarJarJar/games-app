//
//  CompaniesList.swift
//  Gamescg
//
//  Created by Ayaan Shahab on 2022-08-29.
//

import SwiftUI

struct CompaniesList: View {
    @State var companies: [Game.Object]
    var body: some View {
        VStack {
            ForEach(companies) {company in
                
                Text(company.company.name)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .bold()
            }
        }
    }
}

