//
//  Category.swift
//  DayKeeperApp
//
//  Created by Dante LaRocco on 2/8/22.
//

import Foundation
import RealmSwift

final class Category : Object, ObjectKeyIdentifiable, Identifiable, Codable {
    @Persisted(primaryKey: true) var _id = UUID()
    @Persisted var UserId : UUID
    @Persisted var Title : String
    @Persisted var Description : String
    @Persisted var Cadence : String
}
