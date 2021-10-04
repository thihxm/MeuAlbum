//
//  StickerCategoryHeaderView.swift
//  MeuAlbum
//
//  Created by Thiago Medeiros on 01/10/21.
//

import UIKit

class StickerCategoryHeaderView: UICollectionReusableView {
    
    var onClickHeader: () -> Void = {}
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 28)
        
        return label
    }()
    
    private lazy var headerButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(clickAction(_:)), for: .touchUpInside)
        
        return button
    }()
    
    func configure(title: String) {
        titleLabel.text = title
    }
    
    @objc func clickAction(_ sender: UITapGestureRecognizer) {
        onClickHeader()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(titleLabel)
        self.addSubview(headerButton)
        
        
        NSLayoutConstraint.activate([
            headerButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            headerButton.leftAnchor.constraint(equalTo: self.leftAnchor),
            headerButton.widthAnchor.constraint(equalTo: self.widthAnchor),
            headerButton.heightAnchor.constraint(equalTo: self.heightAnchor),
            
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
