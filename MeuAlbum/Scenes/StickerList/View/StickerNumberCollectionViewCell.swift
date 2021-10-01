//
//  StickerNumberCollectionViewCell.swift
//  MeuAlbum
//
//  Created by Thiago Medeiros on 30/09/21.
//

import UIKit

class StickerNumberCollectionViewCell: UICollectionViewCell {
    
    public var sticker: Sticker?

    func stickerBorderColor(for type: StickerType) -> UIColor {
        switch type {
        case .badge,
             .special:
            return .gold
        case .team:
            return .silver
        default:
            return .clear
        }
    }
    
    func stickerBorderWidth(for type: StickerType) -> CGFloat {
        switch type {
        case .badge,
             .special,
             .team:
            return 3
        default:
            return 0
        }
    }
    
    private lazy var numberLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        return label
    }()
    
    func configure(using sticker: Sticker) {
        self.sticker = sticker
        numberLabel.text = "\(sticker.number)"
        numberLabel.textColor = sticker.amount > 0 ? .white : .black
        
        self.backgroundColor = sticker.amount > 0 ? .ownedGreen : .white
        self.layer.borderColor = stickerBorderColor(for: sticker.type).cgColor
        self.layer.borderWidth = stickerBorderWidth(for: sticker.type)
        
        self.layer.cornerRadius = self.frame.width / 2
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.sticker = nil
        
        self.addSubview(numberLabel)
        
        NSLayoutConstraint.activate([
            numberLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            numberLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
