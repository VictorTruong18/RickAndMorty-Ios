//
//  RMInfo.swift
//  RickMorty
//
//  Created by Victor Truong on 12/1/22.
//

import Foundation

struct RMInfo : Decodable {
    var count : Int
    var pages : Int
    var next : String?
    var prev : String?
}


