//
//  NasaMediaLibraryPageResponse.swift
//  NasaMediaLibrary
//
//  Created by Dharamshi, Lopa D on 4/3/19.
//  Copyright © 2019 Dharamshi Lopa D. All rights reserved.
//

import Foundation

// NasaMediaLibraryCollectionLinks "links" giving the next page information
struct NasaMediaLibraryItemLink:Decodable{
    let href:String
    let render:String
    let rel:String
    
    enum CodingKeys:String, CodingKey {
        case href
        case render
        case rel
    }
}

// NasaMediaLibraryCollectionItem data "[data]"
struct NasaMediaLibraryCollectionItem:Decodable {
    let mediaLibraryModels: [NasaMediaLibraryModel]
    let href: String
    let links: [NasaMediaLibraryItemLink]
    
    enum CodingKeys:String, CodingKey {
        case mediaLibraryModels = "data"
        case href
        case links
    }
}

// NasaMediaLibraryCollectionLinks "links" giving the next page information
struct NasaMediaLibraryCollectionLink:Decodable{
    let nextPageURL:String
    let prompt:String
    let rel:String
    
    enum CodingKeys:String, CodingKey {
        case nextPageURL = "href"
        case prompt
        case rel
    }
}

// NasaMediaLibraryCollection "collection" object
struct NasaMediaLibraryCollection: Decodable {
    let mediaLibraryCollectionItems: [NasaMediaLibraryCollectionItem]
    let mediaLibraryCollectionLinks:[NasaMediaLibraryCollectionLink]
    
    enum CodingKeys: String, CodingKey {
        case mediaLibraryCollectionItems = "items"
        case mediaLibraryCollectionLinks = "links"
    }
}

// Nasa media library search response
struct NasaMediaLibraryPageResponse: Decodable{
    
    let mediaLibraryCollection:NasaMediaLibraryCollection
    
    enum CodingKeys: String, CodingKey {
        case mediaLibraryCollection = "collection"
    }
}
