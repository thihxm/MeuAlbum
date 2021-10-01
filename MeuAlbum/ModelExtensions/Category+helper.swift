//
//  Category+helper.swift
//  MeuAlbum
//
//  Created by Thiago Medeiros on 30/09/21.
//

import Foundation
import CoreData

public enum CategoryType: Int16 {
    case player = 0
    case team = 1
    case badge = 2
    case special = 3
}

extension Category {
    
    var name: String {
        get {
            return name_ ?? ""
        }
        set {
            name_ = newValue
        }
    }
    
    var type: CategoryType {
        get {
            return CategoryType(rawValue: type_)!
        }
        set {
            type_ = newValue.rawValue
        }
    }
}
