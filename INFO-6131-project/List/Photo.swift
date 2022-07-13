//
//  Photo.swift
//  INFO-6131-project
//
//  Created by Anh Dinh Le on 2022-05-22.
//

import Foundation

struct Photo: Decodable {
    let results: [cellImage]
}

struct cellImage: Decodable {
    let poster_path: String
    let title: String
    let id: Int
}
