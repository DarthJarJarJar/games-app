//
//  SearchedGames.swift
//  Gamescg
//
//  Created by Ayaan Shahab on 2022-08-29.
//

import Foundation

struct SearchedGame: Identifiable, Decodable {
    var id: Int
    var name: String
    var cover: Cover
    
    struct Cover: Identifiable, Codable {
        var id: Int
        var image_id: String
    }
}



