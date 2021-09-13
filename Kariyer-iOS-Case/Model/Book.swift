//
//  Book.swift
//  libraryProject
//
//  Created by Buse Şentürk
//

import Foundation

struct Feed: Codable {
    let feed : Results?
}

struct Results: Codable {
    let results : [Book]?
}

struct Book: Codable,Hashable{
    let artistName: String?
    let releaseDate: String?
    let name: String?
    let artworkUrl100: String?
}
