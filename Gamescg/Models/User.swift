//
//  Games.swift
//  Gamescg
//
//  Created by Ayaan  on 2022-08-27.
//

import Foundation

struct User: Identifiable, Decodable {
    var id: Int
    var name: String
    var cover: Cover
    var summary: String
    
    struct Cover: Identifiable, Codable {
        var id: Int
        var image_id: String
    }
}


