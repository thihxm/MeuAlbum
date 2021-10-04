//
//  ViewController.swift
//  MeuAlbum
//
//  Created by Thiago Medeiros on 27/09/21.
//

import UIKit

private let reuseIdentifier = "CalendarViewCell"

class ViewController: UIViewController {
    
    var categories: [Category] = []
    
    func generateLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        
        let stickerItem = NSCollectionLayoutItem(layoutSize: itemSize)
        stickerItem.contentInsets = NSDirectionalEdgeInsets(
            top: 8,
            leading: 8,
            bottom: 8,
            trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: stickerItem,
            count: 2)
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private lazy var categoriesCollectionView: UICollectionView = {
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: generateLayout())
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.register(CategoryCalendarCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .clear
        
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Meu Álbum"
        view.backgroundColor = .systemBackground
        
        view.addSubview(categoriesCollectionView)
        
        NSLayoutConstraint.activate([
            categoriesCollectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            categoriesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoriesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoriesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize(width: view.frame.width, height: 50)
        let stickerCollectionVC = StickerCalendarCollectionViewController(collectionViewLayout: layout)
        navigationController?.pushViewController(stickerCollectionVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let context = PersistenceController.preview.container.viewContext

        do {
            categories = try context.fetch(Category.fetch())
        } catch {
            print(error)
        }
        categoriesCollectionView.reloadData()
    }


}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = categoriesCollectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CategoryCalendarCollectionViewCell
        cell.configure(using: categories[indexPath.row], navigationController: self.navigationController)
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize(width: view.frame.width, height: 50)
        let stickerCollectionVC = StickerCalendarCollectionViewController(collectionViewLayout: layout)
        navigationController?.pushViewController(stickerCollectionVC, animated: true)
    }
}

