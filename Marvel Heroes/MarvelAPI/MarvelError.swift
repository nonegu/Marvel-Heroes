//
//  MarvelError.swift
//  Marvel Heroes
//
//  Created by Ender on 27.09.2020.
//

import Foundation

struct MarvelError: Decodable {
    let code: String?
    let message: String?
}
