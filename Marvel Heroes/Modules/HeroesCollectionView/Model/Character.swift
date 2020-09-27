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
    
    init(realmCharacter: RealmCharacter) {
        self.id = realmCharacter.id
        self.name = realmCharacter.name
        self.description = realmCharacter.heroDescription
        self.thumbnail = Thumbnail(
            path: realmCharacter.imagePath,
            imageExtension: realmCharacter.imageExtension
        )
    }
}

struct Thumbnail: Decodable {
    let path: String?
    var imageURL: URL?
    let imageExtension: String?
    
    enum CodingKeys: String, CodingKey {
        case path
        case imageExtension = "extension"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        imageExtension = try container.decodeIfPresent(String.self, forKey: .imageExtension)
        path = try container.decodeIfPresent(String.self, forKey: .path)
        
        if let path = path {
            imageURL = URL(string: path)
        }
    }
    
    init(path: String?, imageExtension: String?) {
        self.path = path
        self.imageExtension = imageExtension
        
        if let path = path {
            imageURL = URL(string: path)
        }
    }
}

/// Defines the type and size of thumbnail
/// Used in Thumbnail URL to retrieve related image
enum ThumbnailTypes: String {
    case portraitSmall = "portrait_small"
    case portraitMedium = "portrait_medium"
    case portraitXLarge = "portrait_xlarge"
    case portraitFantastic = "portrait_fantastic"
    case portraitUncanny = "portrait_uncanny"
    case portraitIncredible = "portrait_incredible"
    
    case standardSmall = "standard_small"
    case standardMedium = "standard_medium"
    case standardLarge = "standard_large"
    case standardXLarge = "standard_xlarge"
    case standardFantastic = "standard_fantastic"
    case standardAmazing = "standard_amazing"
    
    case landscapeSmall = "landscape_small"
    case landscapeMedium = "landscape_medium"
    case landscapeLarge = "landscape_large"
    case landscapeXLarge = "landscape_xlarge"
    case landscapeAmazing = "landscape_amazing"
    case landscapeIncredible = "landscape_incredible"
}
