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
    
    func stickerBorderColor(for type: StickerType) -> UIColor {
        switch type {
        case .badge,
             .special:
            return .gold
        case .team:
            return .silver
        default:
            return .wineRed
        }
    }
    
    func addShadow(to view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.25
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 4
    }
    
    private lazy var borderView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.layer.borderColor = UIColor.wineRed.cgColor
        view.layer.borderWidth = LayoutMetrics.borderWidth
        view.layer.cornerRadius = LayoutMetrics.viewRadius
        
        addShadow(to: view)
        
        return view
    }()
    
    private lazy var numberLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: LayoutMetrics.numberFontSize, weight: .bold)
        
        return label
    }()
    
    private lazy var amountBadge: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .tintColor
        view.layer.cornerRadius = LayoutMetrics.amountBadgeSize / 2
        
        addShadow(to: view)
        
        return view
    }()
    
    private lazy var amountLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false

        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: LayoutMetrics.amountBadgeFontSize, weight: .regular)
        label.superview?.backgroundColor = .red

        return label
    }()
    
    func configure(using sticker: Sticker) {
        self.sticker = sticker
        
        borderView.layer.borderColor = stickerBorderColor(for: sticker.type).cgColor
        numberLabel.text = "\(sticker.number)"
        numberLabel.textColor = sticker.amount > 0 ? .white : .wineRed
        amountLabel.text = "\(sticker.amount)"
        
        amountBadge.isHidden = sticker.amount <= 0
        
        borderView.backgroundColor = sticker.amount > 0 ? .ownedGreen : .white
        self.backgroundColor = .clear
        self.layer.cornerRadius = LayoutMetrics.viewRadius
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.sticker = nil
        
//        borderView.frame = self.bounds
        
        self.addSubview(borderView)
        self.addSubview(numberLabel)
//        self.addSubview(amountLabel)
        amountBadge.addSubview(amountLabel)
        self.addSubview(amountBadge)
        
        self.bringSubviewToFront(amountLabel)
        
        NSLayoutConstraint.activate([
            borderView.widthAnchor.constraint(equalTo: self.widthAnchor),
            borderView.heightAnchor.constraint(equalTo: self.heightAnchor),
            borderView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            borderView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            numberLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            numberLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            amountBadge.widthAnchor.constraint(equalToConstant: LayoutMetrics.amountBadgeSize),
            amountBadge.heightAnchor.constraint(equalToConstant: LayoutMetrics.amountBadgeSize),
            amountBadge.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: LayoutMetrics.amountBadgeOffsetX),
            amountBadge.topAnchor.constraint(equalTo: self.topAnchor, constant: LayoutMetrics.amountBadgeOffsetY),
            amountLabel.centerXAnchor.constraint(equalTo: amountBadge.centerXAnchor),
            amountLabel.centerYAnchor.constraint(equalTo: amountBadge.centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private struct LayoutMetrics {
        static let amountBadgeSize: CGFloat = 24
        static let amountBadgeFontSize: CGFloat = 14
        static let amountBadgeOffsetX: CGFloat = 8
        static let amountBadgeOffsetY: CGFloat = -4
        static let viewRadius: CGFloat = 16
        static let borderWidth: CGFloat = 3
        static let numberFontSize: CGFloat = 32
    }

}
