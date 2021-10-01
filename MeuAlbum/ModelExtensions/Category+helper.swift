//
//  Category+helper.swift
//  MeuAlbum
//
//  Created by Thiago Medeiros on 30/09/21.
//

import Foundation
import CoreData

public enum CategoryType: Int16 {
    case special = 0
    case stadium = 1
    case hostCity = 2
    case team = 3
    case legends = 4
}

extension Category {
    
    convenience init(name: String, type: CategoryType = .team, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.name_ = name
        self.type_ = type.rawValue
    }
    
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
    
    public override func awakeFromInsert() {
        setPrimitiveValue("", forKey: CategoryProperties.name)
        setPrimitiveValue(CategoryType.team.rawValue, forKey: CategoryProperties.type)
    }
    
    static func delete(at offset: IndexSet, for stickers: [Sticker]) {
        if let first = stickers.first, let viewContext = first.managedObjectContext {
            offset.map { stickers[$0] }.forEach(viewContext.delete)
        }
    }
    
    static func fetch() -> NSFetchRequest<Sticker> {
        let request = NSFetchRequest<Sticker>(entityName: "Category")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Category.type_, ascending: true)]
        request.predicate = NSPredicate(format: "TRUEPREDICATE")
        return request
    }
    
    static func example(context: NSManagedObjectContext) -> Category {
        return Category(name: "Brasil", type: .team, context: context)
    }
}

struct CategoryProperties {
    static let name = "name_"
    static let type = "type_"
}
