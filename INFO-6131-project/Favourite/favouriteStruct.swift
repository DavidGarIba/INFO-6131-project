//
//  favouriteStruct.swift
//  INFO-6131-project
//
//  Created by Anh Dinh Le on 2022-07-11.
//

import Foundation
struct favouriteStruct: Decodable {
    let results: [favCell]
    let total_results: Int
}

struct favCell: Decodable {
    let poster_path: String
    let title: String
    let id: Int
}
