//
//  NasaMediaResponseError.swift
//  NasaMediaLibrary
//
//  Created by Dharamshi, Lopa D on 4/3/19.
//  Copyright © 2019 Dharamshi Lopa D. All rights reserved.
//

import Foundation

enum NasaMediaResponseError: Error {
    case network
    case decoding
    
    var reason: String {
        switch self {
        case .network:
            return "An error occurred while fetching nasa media response"
        case .decoding:
            return "An error occurred while decoding nasa media response"
        }
    }
}
