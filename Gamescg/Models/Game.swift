//
//  Game.swift
//  Gamescg
//
//  Created by Ayaan  on 2022-08-27.
//

import Foundation

struct Game: Identifiable, Decodable {
    
    
    
    
    var id: Int
    var name: String
    var cover: Cover
    var summary: String
    var involved_companies: [Object]
    var screenshots: [Screenshot]
    var platforms: [Platform]
    var genres: [Genre]
    var first_release_date: Int
    
    struct Genre: Identifiable, Codable {
        var id: Int
        var name: String
    }
    
    struct Platform: Identifiable, Codable {
        var id: Int
        var abbreviation: String
    }
    
    struct Screenshot: Identifiable, Codable {
        var id: Int
        var image_id: String
    }
    struct Object: Identifiable, Codable {
        var company: Company
        var id: Int
    }
    struct Company: Identifiable, Codable {
        var id: Int
        var name: String
    }
    struct Cover: Identifiable, Codable {
        var id: Int
        var image_id: String
    }
}
