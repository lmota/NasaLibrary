//
//  NasaMediaLibraryModel.swift
//  NasaMediaLibrary
//
//  Created by Dharamshi, Lopa D on 4/2/19.
//  Copyright © 2019 Dharamshi Lopa D. All rights reserved.
//

import Foundation

struct NasaMediaLibraryModel : Decodable{
    var title:String
    var description:String
    var date:String
    
    enum CodingKeys: String, CodingKey {
        case date = "date_created"
        case title
        case description
    }
    
    init(title: String, date:String, description: String) {
        self.title = title
        self.description = description
        self.date = date
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let title = try container.decode(String.self, forKey: .title)
        let date = try container.decode(String.self, forKey: .date)
        let description = try container.decode(String.self, forKey: .description)
        
        self.init(title: title, date: date, description: description)
    }
    
}
