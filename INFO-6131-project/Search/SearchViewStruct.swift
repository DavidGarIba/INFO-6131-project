//
//  SearchViewStruct.swift
//  INFO-6131-project
//
//  Created by Anh Dinh Le on 2022-06-06.
//

import Foundation

struct SearchViewStruct: Decodable {
    let results: [SearchDetail]
}
    
struct SearchDetail: Decodable {
    let id: Int
    let original_title: String
}

let NullableList = [
    SearchDetail(id: 0, original_title: "" )
]
