//
//  RealmCharacter.swift
//  Marvel Heroes
//
//  Created by Ender on 26.09.2020.
//

import Foundation
import RealmSwift

class RealmCharacter: Object {
    @objc dynamic var id = Int()
    @objc dynamic var name: String?
    @objc dynamic var heroDescription: String?
    @objc dynamic var imagePath: String?
    @objc dynamic var imageExtension: String?
    
    init(from character: Character) {
        self.id = character.id ?? 0
        self.name = character.name
        self.heroDescription = character.description
        self.imagePath = character.thumbnail?.path
        self.imageExtension = character.thumbnail?.imageExtension
    }
    
    required init() {
        self.name = nil
        self.heroDescription = nil
        self.imagePath = nil
        self.imageExtension = nil
    }
}
