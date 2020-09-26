//
//  RealmService.swift
//  Marvel Heroes
//
//  Created by Ender on 26.09.2020.
//

import Foundation
import RealmSwift

final class RealmService {
    static private let realm = try! Realm()
    
    public static func save(objects: Object..., completion: @escaping (Result<Bool, Error>) -> Void) {
        objects.forEach { (object) in
            do {
                try realm.write {
                    realm.add(object)
                }
                completion(.success(true))
            }
            catch {
                completion(.failure(error))
            }
        }
    }

    public static func delete(object: Object, completion: @escaping (Result<Bool, Error>) -> Void) {
        do {
            try realm.write {
                realm.delete(object)
            }
            completion(.success(true))
        } catch {
            completion(.failure(error))
        }
    }
    
    public static func getObjects<T: Object>(ofType: T.Type) -> Results<T> {
        let objects = realm.objects(T.self)
        return objects
    }
}
