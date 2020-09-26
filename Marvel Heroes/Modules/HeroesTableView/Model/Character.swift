//
//  Character.swift
//  Marvel Heroes
//
//  Created by Ender on 26.09.2020.
//

import Foundation

struct Character: Decodable {
    let id: Int?
    let name: String?
    let description: String?
    let thumbnail: Thumbnail?
}

struct Thumbnail: Decodable {
    let path: String?
    let imageExtension: String?
}
