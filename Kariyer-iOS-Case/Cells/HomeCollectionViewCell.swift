//
//  HomeCollectionViewCell.swift
//  libraryProject
//
//  Created by Buse Şentürk on 26.07.2021.
//

import UIKit
protocol FavBookDelegate {
    func bookFaved(book: Book)
    func bookUnfaved(book: Book)
}
class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var likedButton: UIButton!
    @IBOutlet weak var bookPoster: UIImageView!
    @IBOutlet weak var bookName: UILabel!
    
    var book : Book!
    var delegate : FavBookDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func likedButton(_ sender: UIButton) {
        if let tmp=self.book {
            if !likedButton.isSelected{
                self.delegate?.bookFaved(book: tmp)
            } else {
                self.delegate?.bookUnfaved(book: tmp)
            }
        }
        likedButton.isSelected = !likedButton.isSelected
        likedButton.tintColor = .systemYellow
        likedButton.setImage(UIImage(systemName: "star.fill"), for: .selected)
    }
}
