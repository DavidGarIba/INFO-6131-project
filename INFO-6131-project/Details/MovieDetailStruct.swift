//
//  MovieDetailStruct.swift
//  INFO-6131-project
//
//  Created by Anh Dinh Le on 2022-05-23.
//

import Foundation

struct MovieDetailStruct: Decodable {
    let poster_path: String
    let title: String
    let overview: String
    let vote_average: Double
}
