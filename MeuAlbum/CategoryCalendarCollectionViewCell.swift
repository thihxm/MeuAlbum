//
//  CategoryCalendarCollectionViewCell.swift
//  MeuAlbum
//
//  Created by Thiago Medeiros on 04/10/21.
//

import UIKit

class CategoryCalendarCollectionViewCell: UICollectionViewCell {
    
    private let cellIdentifier = "CalendarStickerCell"
    
    var category: Category?
    var stickers: [Sticker] = []
    var navigationController: UINavigationController?
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .fill
        stack.spacing = 8
        stack.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        return stack
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "Category"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        
        return label
    }()
    
    private lazy var stickersCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 24, height: 24)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 8, right: 8)
        
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.register(StickerNumberCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.backgroundColor = .clear
        
        return collectionView
    }()
    
    func configure(using category: Category, navigationController: UINavigationController?) {
        self.category = category
        titleLabel.text = category.name
        let stickers = category.stickers?.allObjects as! [Sticker]
        self.stickers = stickers.sorted(by: { $0.number < $1.number })
        self.navigationController = navigationController
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        category = nil
        
        stickersCollectionView.dataSource = self
        stickersCollectionView.delegate = self
        
        self.addSubview(titleLabel)
        self.addSubview(stickersCollectionView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8),
            
            stickersCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            stickersCollectionView.leftAnchor.constraint(equalTo: self.leftAnchor),
            stickersCollectionView.rightAnchor.constraint(equalTo: self.rightAnchor),
            stickersCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CategoryCalendarCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
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
        let cell = stickersCollectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! StickerNumberCollectionViewCell
        cell.configure(using: stickers[indexPath.row])
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize(width: self.frame.width, height: 50)
        let stickerCollectionVC = StickerCalendarCollectionViewController(collectionViewLayout: layout)
        self.navigationController?.pushViewController(stickerCollectionVC, animated: true)
    }
}
