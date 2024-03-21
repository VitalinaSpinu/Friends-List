//
//  Picture.swift
//  Project 10-12
//
//  Created by Dmitrii Vrabie on 27.02.2024.
//

import UIKit

class Picture: NSObject, Codable {
    
    var image: String
    var name: String
    
    init(image: String, name: String) {
        self.image = image
        self.name = name
    }

}
