//
//  CategoryCollectionViewController.swift
//  MeuAlbum
//
//  Created by Thiago Medeiros on 01/10/21.
//

import UIKit

private let reuseIdentifier = "Cell"

class CategoryCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var stickers: [Sticker] = []
    
    func generateLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(2/3),
            heightDimension: .fractionalHeight(1.0))
        
        let stickerItem = NSCollectionLayoutItem(layoutSize: itemSize)
        stickerItem.contentInsets = NSDirectionalEdgeInsets(
            top: 8,
            leading: 8,
            bottom: 8,
            trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1/4))

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: stickerItem,
            count: 3)
        
        group.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 8,
            bottom: 0,
            trailing: 8)
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
        
    var stickerCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        title = "Brasil"
        view.backgroundColor = .white

        // Register cell classes
        stickerCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: generateLayout())
        stickerCollectionView.register(StickerCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        view.addSubview(stickerCollectionView)
        
        stickerCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stickerCollectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            stickerCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stickerCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stickerCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        stickerCollectionView.delegate = self
        stickerCollectionView.dataSource = self
        stickerCollectionView.backgroundColor = .clear

        // Do any additional setup after loading the view.
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        let context = PersistenceController.preview.container.viewContext
//        
//        do {
//            stickers = try context.fetch(Sticker.fetch())
//        } catch {
//            print(error)
//        }
//    }

    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return stickers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = stickerCollectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! StickerCell
        cell.configure(using: stickers[indexPath.row])
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let clickedCell = collectionView.cellForItem(at: indexPath)! as! StickerCell
        let sticker = clickedCell.sticker
        sticker?.amount += 1
        PersistenceController.preview.save()
        collectionView.reloadData()
    }
}

extension CategoryCollectionViewController: StickerCalendarCollectionDelegate {
    func selectCategory(_ category: Category) {
        let stickers = category.stickers?.allObjects as! [Sticker]
        self.stickers = stickers.sorted(by: { $0.number < $1.number })
//        self.stickerCollectionView?.reloadData()
    }
}
