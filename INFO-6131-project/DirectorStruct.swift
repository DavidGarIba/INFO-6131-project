//
//  DirectorStruct.swift
//  INFO-6131-project
//
//  Created by Anh Dinh Le on 2022-06-07.
//

import Foundation

struct DirectorStruct: Decodable {
    let crew: [Directing]
    
}
    
struct Directing: Decodable {
    let known_for_department: String
    let name: String
}
