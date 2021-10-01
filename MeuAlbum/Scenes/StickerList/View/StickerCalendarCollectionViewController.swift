//
//  StickerCalendarCollectionViewController.swift
//  MeuAlbum
//
//  Created by Thiago Medeiros on 30/09/21.
//

import UIKit
import CoreData

private let reuseIdentifier = "StickerNumberCell"

class StickerCalendarCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var categories: [Category] = []
    var stickers: [Sticker] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        self.collectionView!.register(StickerCategoryHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(StickerCategoryHeaderView.self)")
        self.collectionView!.register(StickerNumberCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let context = PersistenceController.preview.container.viewContext
        
        do {
            categories = try context.fetch(Category.fetch())
//            stickers = try context.fetch(Sticker.fetch())
        } catch {
            print(error)
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categories.count
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return categories.first!.stickers!.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(
                  ofKind: kind,
                  withReuseIdentifier: "\(StickerCategoryHeaderView.self)",
                  for: indexPath)
            
            guard let categoryHeader = headerView as? StickerCategoryHeaderView
            else { return headerView }
            
            categoryHeader.configure(title: categories[indexPath.section].name)
            return categoryHeader
        default:
            // 5
            assert(false, "Invalid element type")
        }
    }
    

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> StickerNumberCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! StickerNumberCollectionViewCell
        // Configure the cell
        let stickers = categories[indexPath.section].stickers?.allObjects as! [Sticker]
        let sticker = stickers.sorted(by: { $0.number < $1.number })[indexPath.row]
        cell.configure(using: sticker)
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 40, height: 40)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Tapped cell at: \(indexPath.section): \(indexPath.row)")
        let clickedCell = collectionView.cellForItem(at: indexPath)! as! StickerNumberCollectionViewCell
        let sticker = clickedCell.sticker
        sticker?.amount += 1
        PersistenceController.preview.save()
        collectionView.reloadData()
    }
}
