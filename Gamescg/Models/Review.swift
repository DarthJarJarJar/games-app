//
//  Review.swift
//  Gamescg
//
//  Created by Ayaan  on 2022-08-31.
//

import Foundation

struct Review: Identifiable, Decodable, Equatable {
    var id = UUID()
    var gameId: Int?
    var gameName: String?
    var rating: Int?
    var review: String?
    var reviewAt: Int
    var reviewBy: String?
    var reviewerName: String?
    var spoiler: Bool
}
