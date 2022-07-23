//
//  PlayVideoStruct.swift
//  INFO-6131-project
//
//  Created by Anh Dinh Le on 2022-07-22.
//

import Foundation

struct PlayVideoStruct: Decodable {
    let results: [VideoInfo]
}

struct VideoInfo: Decodable {
    let key: String
}
