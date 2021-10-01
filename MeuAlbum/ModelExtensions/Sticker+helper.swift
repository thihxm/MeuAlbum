//
//  Sticker+helper.swift
//  MeuAlbum
//
//  Created by Thiago Medeiros on 30/09/21.
//

import Foundation
import CoreData

public enum StickerType: Int16 {
    case player = 0
    case team = 1
    case badge = 2
    case special = 3
}

extension Sticker {
    
    convenience init(amount: Int16 = 0, name: String, number: Int16, type: StickerType = .player, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.amount_ = amount
        self.name_ = name
        self.number_ = number
        self.type_ = type.rawValue
    }
    
    var amount: Int16 {
        get {
            return amount_
        }
        set {
            amount_ = newValue
        }
    }
    
    var name: String {
        get {
            return name_ ?? ""
        }
        set {
            name_ = newValue
        }
    }
    
    var number: Int16 {
        get {
            return number_
        }
        set {
            number_ = newValue
        }
    }
    
    var type: StickerType {
        get {
            return StickerType(rawValue: type_)!
        }
        set {
            type_ = newValue.rawValue
        }
    }
    
    public override func awakeFromInsert() {
        setPrimitiveValue(0, forKey: StickerProperties.amount)
        setPrimitiveValue("", forKey: StickerProperties.name)
        setPrimitiveValue(1, forKey: StickerProperties.number)
        setPrimitiveValue(StickerType.player.rawValue, forKey: StickerProperties.type)
    }
    
    static func delete(at offset: IndexSet, for stickers: [Sticker]) {
        if let first = stickers.first, let viewContext = first.managedObjectContext {
            offset.map { stickers[$0] }.forEach(viewContext.delete)
        }
    }
    
    static func fetch() -> NSFetchRequest<Sticker> {
        let request = NSFetchRequest<Sticker>(entityName: "Sticker")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Sticker.number_, ascending: true)]
        request.predicate = NSPredicate(format: "TRUEPREDICATE")
        return request
    }
    
    static func example(context: NSManagedObjectContext) -> Sticker {
        return Sticker(
            amount: 0,
            name: "Kaká",
            number: 1,
            type: .player,
            context: context)
    }
}

struct StickerProperties {
    static let amount = "amount_"
    static let name = "name_"
    static let number = "number_"
    static let type = "type_"
}
