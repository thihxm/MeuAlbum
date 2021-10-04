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
    let stickerCollectionVC = CategoryCollectionViewController()
    var delegate: StickerCalendarCollectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        self.collectionView!.register(StickerCategoryHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(StickerCategoryHeaderView.self)")
        self.collectionView!.register(StickerNumberCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.collectionView!.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 24, right: 16)
        
        self.delegate = stickerCollectionVC
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        longPressRecognizer.minimumPressDuration = 0.5
        longPressRecognizer.delegate = self
        longPressRecognizer.delaysTouchesBegan = true
        self.collectionView!.addGestureRecognizer(longPressRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
        
        let context = PersistenceController.preview.container.viewContext
        
        do {
            categories = try context.fetch(Category.fetch())
        } catch {
            print(error)
        }
        self.collectionView.reloadData()
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
            categoryHeader.onClickHeader = {
                self.delegate?.selectCategory(self.categories[indexPath.section])
                self.navigationController?.pushViewController(self.stickerCollectionVC, animated: true)
            }
            
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
        let clickedCell = collectionView.cellForItem(at: indexPath)! as! StickerNumberCollectionViewCell
        let sticker = clickedCell.sticker
        sticker?.amount += 1
        PersistenceController.preview.save()
        collectionView.reloadData()
    }
}

extension StickerCalendarCollectionViewController: UIGestureRecognizerDelegate {
    @objc func handleLongPress(gesture : UILongPressGestureRecognizer!) {
        if gesture.state != .ended {
            return
        }

        let p = gesture.location(in: self.collectionView)

        if let indexPath = self.collectionView.indexPathForItem(at: p) {
            let clickedCell = self.collectionView.cellForItem(at: indexPath)! as! StickerNumberCollectionViewCell
            let sticker = clickedCell.sticker!
            if sticker.amount > 0 {
                sticker.amount -= 1
            }
            PersistenceController.preview.save()
            self.collectionView.reloadData()
        } else {
            print("couldn't find index path")
        }
    }
}


protocol StickerCalendarCollectionDelegate {
    func selectCategory(_ category: Category)
}
