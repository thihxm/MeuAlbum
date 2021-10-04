//
//  PersistenceController.swift
//  MeuAlbum
//
//  Created by Thiago Medeiros on 30/09/21.
//

import CoreData

class PersistenceController {
    static let shared = PersistenceController()
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        let brazil = Category(name: "Brasil", type: .team, context: viewContext)

        let badge = Sticker(
            amount: 0,
            name: "Brasão Brasil",
            number: 1,
            type: .badge,
            context: viewContext)
        brazil.addToStickers(badge)

        let teamPhoto = Sticker(
            amount: 0,
            name: "Time Brasil",
            number: 2,
            type: .team,
            context: viewContext)
        brazil.addToStickers(teamPhoto)

        let samplePlayer = Sticker(
            amount: 0,
            name: "Kaká",
            number: 3,
            type: .player,
            context: viewContext)
        brazil.addToStickers(samplePlayer)
        
        for i in 4...20 {
            let sticker = Sticker(
                amount: (i % 2 == 0 || i % 3 == 0) ? Int16(i) : 0,
                name: "Kaká",
                number: Int16(i),
                type: .player,
                context: viewContext)
            brazil.addToStickers(sticker)
        }
        
        let italy = Category(name: "Itália", type: .team, context: viewContext)

        let italyBadge = Sticker(
            amount: 0,
            name: "Brasão Itália",
            number: 1,
            type: .badge,
            context: viewContext)
        italy.addToStickers(italyBadge)

        let italyTeamPhoto = Sticker(
            amount: 0,
            name: "Time Itália",
            number: 2,
            type: .team,
            context: viewContext)
        italy.addToStickers(italyTeamPhoto)

        let sampleItalyPlayer = Sticker(
            amount: 0,
            name: "Verratti",
            number: 3,
            type: .player,
            context: viewContext)
        italy.addToStickers(sampleItalyPlayer)
        
        for i in 4...20 {
            let sticker = Sticker(
                amount: i % 2 != 0 ? Int16(i) : 0,
                name: "Verratti",
                number: Int16(i),
                type: .player,
                context: viewContext)
            italy.addToStickers(sticker)
        }
        
        do {
            try viewContext.save()
        } catch let error as NSError {
            fatalError("Unresolved error: \(error), \(error.userInfo)")
        }

        return result
    }()
    
    
    // MARK: - Core Data stack
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "MeuAlbum")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error: \(error), \(error.userInfo)")
            }
        }
    }
    
    // MARK: - Core Data Saving support

    func save() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
//    func saveContext(backgroundContext: NSManagedObjectContext? = nil) {
//        let context = backgroundContext ?? viewContext
//        guard context.hasChanges else { return }
//        do {
//            try context.save()
//        }
//    }
}
