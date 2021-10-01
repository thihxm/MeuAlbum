//
//  ViewController.swift
//  MeuAlbum
//
//  Created by Thiago Medeiros on 27/09/21.
//

import UIKit

class ViewController: UIViewController {
//    private lazy var stickerCollectionView: StickerCalendarCollectionViewController = {
//        let collectionView = StickerCalendarCollectionViewController()
//
//        collectionView.view.translatesAutoresizingMaskIntoConstraints = false
//
////        label.textColor = .black
////        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
////        label.layer.cornerRadius = LayoutMetrics.borderRadius
//
//        return collectionView
//    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Teste"
        view.backgroundColor = .blue
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize(width: view.frame.width, height: 50)
        let stickerCollectionVC = StickerCalendarCollectionViewController(collectionViewLayout: layout)
        navigationController?.pushViewController(stickerCollectionVC, animated: true)
    }


}

