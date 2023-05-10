//
//  RMCharacter.swift
//  RickMorty
//
//  Created by Victor Truong on 11/25/22.
//

import Foundation

struct Name : Decodable{
    var name : String
    var url : String
}

struct RMCharacter : Decodable {
    
    var id : Int
    var name : String
    var status : String
    var species : String
    var image : String?
    var origin : Name
    var episode : [String]
}
