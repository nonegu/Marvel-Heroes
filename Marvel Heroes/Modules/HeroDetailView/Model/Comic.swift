//
//  Comic.swift
//  Marvel Heroes
//
//  Created by Ender on 26.09.2020.
//

import Foundation

struct Comic: Decodable {
    let id: Int?
    let title: String?
    let description: String?
    let thumbnail: Thumbnail?
    let pageCount: Int?
}

enum ComicOrderByType: String {
    case onsaleDateDesc = "-onsaleDate"
    case onsaleDateAsc = "onsaleDate"
}
