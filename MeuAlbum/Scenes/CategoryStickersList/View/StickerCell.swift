//
//  StickerCell.swift
//  MeuAlbum
//
//  Created by Thiago Medeiros on 27/09/21.
//

import UIKit
import SwiftUI

class StickerCell: UICollectionViewCell {
    
    public var sticker: Sticker?
    
    private lazy var numberLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = sticker!.amount > 0 ? .white : .wineRed
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        
        return label
    }()
    
    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        return label
    }()
    
    func configure(using sticker: Sticker) {
        self.sticker = sticker
        print(sticker.number)
        
        numberLabel.text = "\(sticker.number)"
        nameLabel.text = sticker.name
        amountLabel.text = "\(sticker.amount)"
        
        self.backgroundColor = sticker.amount > 0 ? .ownedGreen : .white
        self.layer.borderColor = UIColor.wineRed.cgColor
        self.layer.borderWidth = 3
        self.layer.cornerRadius = 16
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        addSubview(numberLabel)
        addSubview(nameLabel)
        addSubview(amountLabel)
        
        NSLayoutConstraint.activate([
            numberLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            numberLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            amountLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            amountLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

}
