//
//  DetailViewController.swift
//  libraryProject
//
//  Created by Buse Şentürk on 31.07.2021.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var bookPoster: UIImageView!
    @IBOutlet weak var bookName: UILabel!
    @IBOutlet weak var bookArtistName: UILabel!
    @IBOutlet weak var likedButton: UIBarButtonItem!
    @IBOutlet weak var bookReleaseDate: UILabel!
    
    var book : Book?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBook()
        setFavouritedBookButton()
    }
    
    private func setBook() {
        guard let detailBook = book else { return }
        bookName.text = detailBook.name
        bookArtistName.text = detailBook.artistName
        bookReleaseDate.text = detailBook.releaseDate?.convertDateFormater()
        bookPoster.image = getPosters(book: detailBook)
    }
    
    private func setFavouritedBookButton() {
        guard let detailBook = book else { return }
        if FavoritedBooksModel.favoritedBooks.contains(detailBook) {
            likedButton.image = UIImage(systemName: "star.fill")
            likedButton.tintColor = .systemYellow
        } else {
            likedButton.image = UIImage(systemName: "star")
        }
    }
    
    @IBAction func likedButton(_ sender: Any) {
        guard let detailBook = book else { return }
        if FavoritedBooksModel.favoritedBooks.contains(detailBook) {
            guard let index = FavoritedBooksModel.favoritedBooks.firstIndex(of: detailBook) else { return }
            FavoritedBooksModel.favoritedBooks.remove(at: index)
            likedButton.image = UIImage(systemName: "star")
        } else {
            FavoritedBooksModel.favoritedBooks.append(detailBook)
            likedButton.image = UIImage(systemName: "star.fill")
            likedButton.tintColor = .systemYellow
        }
        NotificationCenter.default.post(name: Notification.Name("updateFavBookArray"), object: nil, userInfo: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

