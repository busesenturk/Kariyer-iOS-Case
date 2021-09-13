//
//  SearchableViewController.swift
//  libraryProject
//
//  Created by Buse Şentürk on 28.07.2021.
//

import UIKit

class SearchableViewController: UIViewController{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var searchTableView: UITableView!
    
    private let bookDataSource = BookDataSource()
    private var bookArray : [Book] = []
    private var filteredData: [Book]!
    private var selectedIndex = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filteredData = bookArray
        searchBar.delegate = self
        searchTableView.dataSource = self
        searchTableView.delegate = self
        bookDataSource.delegate = self
        bookDataSource.loadListOfBooks(currentPage:1)
        searchTableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
    }
    
    @IBAction func backToHomeScreen(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - SearchBar
extension SearchableViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = []
        if searchText == "" {
            filteredData = bookArray
        }
        else{
            for book in bookArray {
                if let name = book.name {
                    if name.lowercased().contains(searchText.lowercased()) {
                        filteredData.append(book)
                    }
                } else {
                    continue
                }
            }
        }
        self.searchTableView.reloadData()
    }
}

//MARK: - Navigation
extension SearchableViewController {
    func goToBookDetailPage() {
        guard let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
        detailVC.book = filteredData[selectedIndex]
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

//MARK: - BookDataSourceDelegate
extension SearchableViewController : BookDataSourceDelegate {
    func BookListLoaded(bookList: [Book]) {
        self.bookArray = bookList
        self.filteredData = bookList
        self.searchTableView.reloadData()
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension SearchableViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SearchTableViewCell
        let book = filteredData[indexPath.row]
        let bookPoster = getPosters(book: book)
        cell.bookName?.text = book.name
        cell.bookArtistName?.text = book.artistName
        cell.bookReleaseDate?.text = book.releaseDate?.convertDateFormater()
        cell.bookPoster?.image = bookPoster
        return cell
    }
    
    // MARK: - To reach the book detail page
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        goToBookDetailPage()
    }
}

