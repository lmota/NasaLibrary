//
//  NasaMediaResponseError.swift
//  NasaMediaLibrary
//
//  Created by Dharamshi, Lopa D on 4/3/19.
//  Copyright © 2019 Dharamshi Lopa D. All rights reserved.
//

import Foundation

/**
 * enum for the response failure.
 */
enum NasaMediaResponseError: Error {
    case network
    case decoding
    
    var reason: String {
        switch self {
        case .network:
            return "An error occurred while fetching nasa media response".localizedCapitalized
        case .decoding:
            return "Internal error occured while fetching nasa media response".localizedCapitalized
        }
    }
}
