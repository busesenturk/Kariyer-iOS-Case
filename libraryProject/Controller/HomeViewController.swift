//
//  ViewController.swift
//  libraryProject
//
//  Created by Buse Şentürk on 15.07.2021.
//

import UIKit

class HomeViewController: UIViewController{
    
    @IBOutlet weak var homeCollectionView: UICollectionView!
    @IBOutlet weak var searchbutton: UIBarButtonItem!
    
    private let bookDataSource = BookDataSource()
    private var bookArray : [Book] = []
    private var bookArrayTmp : [Book] = []
    private var currentPage: Int=1
    private var raceCond: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeCollectionView.dataSource = self
        homeCollectionView.delegate = self
        bookDataSource.delegate = self
        bookDataSource.loadListOfBooks(currentPage:1)
        homeCollectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        homeCollectionView.collectionViewLayout = ColumnFlowLayout(numberOfColumns: 2, minColumnSpacing: 10, minLineSpacing: 20)
        NotificationCenter.default.addObserver(self, selector: #selector(updateFavBookArray), name: Notification.Name("updateFavBookArray"), object: nil)
    }

    @objc private func updateFavBookArray() {
        homeCollectionView.reloadData()
    }
    
    @IBAction func searchbutton(_ sender: Any) {
        guard let searchVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchableViewController") as? SearchableViewController else { return }
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    @IBAction func sortbutton(_ sender: Any) {
        let optionMenu = UIAlertController(title: nil, message: "Sort by Release Date", preferredStyle: .actionSheet)
        optionMenu.addAction(UIAlertAction(title: "All of books", style: .default, handler: self.allOfBookHandler))
        optionMenu.addAction(UIAlertAction(title: "Newest to oldest", style: .default, handler: self.newToOldHandler))
        optionMenu.addAction(UIAlertAction(title: "Oldest to newest", style: .default, handler: self.oldToNewHandler))
        optionMenu.addAction(UIAlertAction(title: "Only favorites", style: .default, handler: self.FavoriteHandler))
        optionMenu.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(optionMenu, animated: true, completion: nil)
    }
}

//MARK: - FavBookDelegate
extension HomeViewController: FavBookDelegate {
    func bookFaved(book: Book) {
        FavoritedBooksModel.favoritedBooks.append(book)
    }
    
    func bookUnfaved(book: Book) {
        guard let index = FavoritedBooksModel.favoritedBooks.firstIndex(of: book) else { return }
        FavoritedBooksModel.favoritedBooks.remove(at: index)
    }
}

//MARK: - BookDataSourceDelegate
extension HomeViewController: BookDataSourceDelegate {
    func BookListLoaded(bookList: [Book]) {
        self.bookArray.append(contentsOf: bookList)
        self.bookArrayTmp.append(contentsOf: bookList)
        self.homeCollectionView.reloadData()
    }
}

//MARK: - Methods
extension HomeViewController {
    
    func allOfBookHandler(alert:UIAlertAction!) {
        bookArray=bookArrayTmp
        homeCollectionView.reloadData()
    }
    func newToOldHandler(alert:UIAlertAction!) {
        bookArray=bookArrayTmp
        bookArray.sort(by: sorterForReleaseDateNewToOld(this:that:))
        homeCollectionView.reloadData()
    }
    func oldToNewHandler(alert:UIAlertAction!) {
        bookArray=bookArrayTmp
        bookArray.sort(by: sorterForReleaseDateOldToNew(this:that:))
        homeCollectionView.reloadData()
    }
    func FavoriteHandler(alert:UIAlertAction!) {
        bookArray = FavoritedBooksModel.favoritedBooks
        homeCollectionView.reloadData()
    }
    
    func sorterForReleaseDateNewToOld(this:Book, that:Book) -> Bool {
        return (this.releaseDate ?? "") > (that.releaseDate ?? "")
    }
    func sorterForReleaseDateOldToNew(this:Book, that:Book) -> Bool {
        return (this.releaseDate ?? "") < (that.releaseDate ?? "")
    }
}

//MARK: - ScrollView
extension HomeViewController {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // raceCond=(!raceCond)
        if raceCond {
            let endScrolling = (scrollView.contentOffset.y + scrollView.frame.size.height)
            if endScrolling >= scrollView.contentSize.height {
                currentPage+=1
                bookDataSource.loadListOfBooks(currentPage: currentPage)
            }
        }
        raceCond=(!raceCond)
    }
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension HomeViewController:  UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! HomeCollectionViewCell
        cell.delegate=self
        let book = bookArray[indexPath.row]
        let bookPoster = getPosters(book: book)
        cell.bookName?.text = book.name
        cell.bookPoster?.image = bookPoster
        cell.book = book
        if FavoritedBooksModel.favoritedBooks.contains(book) {            
            cell.likedButton?.isSelected = true
            cell.likedButton.tintColor = .systemYellow
        } else {
            cell.likedButton?.isSelected=false
        }
        cell.likedButton?.setImage(UIImage(systemName: "star.fill"), for: .selected)
        return cell
    }
}
