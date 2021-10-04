//
//  CategoryCollectionViewController.swift
//  MeuAlbum
//
//  Created by Thiago Medeiros on 01/10/21.
//

import UIKit

private let reuseIdentifier = "CategoryCell"

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
        
    private lazy var stickerCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: generateLayout())
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.register(StickerCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .clear
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressRecognizer.minimumPressDuration = 0.5
        longPressRecognizer.delegate = self
        longPressRecognizer.delaysTouchesBegan = true
        collectionView.addGestureRecognizer(longPressRecognizer)
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        view.backgroundColor = .white
        navigationItem.largeTitleDisplayMode = .always

        view.addSubview(stickerCollectionView)
        
        NSLayoutConstraint.activate([
            stickerCollectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            stickerCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stickerCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stickerCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        stickerCollectionView.delegate = self
        stickerCollectionView.dataSource = self
    }

    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
        title = category.name
        let stickers = category.stickers?.allObjects as! [Sticker]
        self.stickers = stickers.sorted(by: { $0.number < $1.number })
        self.stickerCollectionView.reloadData()
    }
}

extension CategoryCollectionViewController: UIGestureRecognizerDelegate {
    @objc func handleLongPress(gesture : UILongPressGestureRecognizer!) {
        if gesture.state != .ended {
            return
        }

        let p = gesture.location(in: self.stickerCollectionView)

        if let indexPath = self.stickerCollectionView.indexPathForItem(at: p) {
            let clickedCell = self.stickerCollectionView.cellForItem(at: indexPath)! as! StickerCell
            let sticker = clickedCell.sticker!
            if sticker.amount > 0 {
                sticker.amount -= 1
            }
            PersistenceController.preview.save()
            self.stickerCollectionView.reloadData()
        } else {
            print("couldn't find index path")
        }
    }
}
