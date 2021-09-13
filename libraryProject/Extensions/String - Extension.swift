//
//  String - Extension.swift
//  libraryProject
//
//  Created by Buse Şentürk on 11.09.2021.
//

import Foundation

extension String {

    // MARK: - Convert date format
    func convertDateFormater() -> String {
        var fixDate = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let originalDate = self
        if let newDate = dateFormatter.date(from: originalDate) {
            dateFormatter.dateFormat = "dd.MM.yyyy"
            fixDate = dateFormatter.string(from: newDate)
        }
        return fixDate
    }
}
