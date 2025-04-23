//
//  ImageModel.swift
//  Hardik's Task
//
//  Created by Hardik D on 23/04/25.
//

import UIKit

struct ImageResponseModel: Codable {
    let results: [ImageDataModel]
}

struct ImageDataModel : Codable {
    let urls: ImageModel
}

struct ImageModel : Codable {
    let full:String
    let regular:String
    let small:String
}
