//
//  BookDataSource.swift
//  libraryProject
//
//  Created by Buse Şentürk on 26.07.2021.
//

import Foundation

protocol BookDataSourceDelegate: AnyObject {
    func BookListLoaded(bookList: [Book])
}

class BookDataSource {

    weak var delegate: BookDataSourceDelegate?
    let baseURL = "https://rss.itunes.apple.com/api/v1/us/books/top-free/all/100/non-explicit.json"
    var pageInterval:Int=20
    func loadListOfBooks(currentPage : Int){
        var bookList : [Book] = []
        let session = URLSession.shared
        
        if let url = URL(string: baseURL){
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let dataTask = session.dataTask(with: request){
                (data, response, error) in
                let decoder = JSONDecoder()
                let feed = try! decoder.decode(Feed.self, from: data!)
                let page:Int=currentPage-1
                guard let bookResults = feed.feed?.results else { return }
                if page*self.pageInterval<bookResults.count{
                    for index in page*self.pageInterval...min(currentPage*self.pageInterval,bookResults.count)-1{
                        bookList.append(bookResults[index])
                    }
                }
                DispatchQueue.main.async {
                    self.delegate?.BookListLoaded(bookList: bookList)
                }
            }
            dataTask.resume()
        }
    }
}

