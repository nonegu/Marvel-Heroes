//
//  MarvelDataContainer.swift
//  Marvel Heroes
//
//  Created by Ender on 26.09.2020.
//

import Foundation

struct MarvelDataContainer<T: Decodable>: Decodable {
    let offset: Int?
    let limit: Int?
    let total: Int?
    let count: Int?
    let results: [T]?
}
