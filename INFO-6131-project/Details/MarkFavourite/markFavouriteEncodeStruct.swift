//
//  markFavouriteEncodeStruct.swift
//  INFO-6131-project
//
//  Created by Anh Dinh Le on 2022-07-12.
//

import Foundation
struct markFavouriteEncodeStruct: Encodable {
    let media_type: String
    let media_id: Int
    let favorite: Bool
    
}
