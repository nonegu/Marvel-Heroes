//
//  MarvelDataWrapper.swift
//  Marvel Heroes
//
//  Created by Ender on 26.09.2020.
//

import Foundation

struct MarvelDataWrapper<T: Decodable>: Decodable {
    let code: Int?
    let status: String?
    let copyright: String?
    let attributionText: String?
    let attributionHTML: String?
    let data: MarvelDataContainer<T>?
    let etag: String?
}
