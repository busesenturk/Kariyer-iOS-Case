//
//  UIViewController-Extension.swift
//  libraryProject
//
//  Created by Buse Şentürk on 12.09.2021.
//

import Foundation
import UIKit

extension UIViewController {
    // MARK: - Get images from api
    func getPosters(book: Book) -> UIImage {
        guard let artworkUrl = book.artworkUrl100, !artworkUrl.isEmpty else { return UIImage() }
        var image : UIImage!
        if let posterURL = URL(string: artworkUrl) {
            do {
                let data = try Data(contentsOf: posterURL)
                image = UIImage(data: data) ?? UIImage()
            }   catch {}
        }
        return image
    }
}
