//
//  NasaMediaLibraryRequest.swift
//  NasaMediaLibrary
//
//  Created by Dharamshi, Lopa D on 4/3/19.
//  Copyright © 2019 Dharamshi Lopa D. All rights reserved.
//

import Foundation

struct NasaMediaLibraryRequest {
    var path: String {
        return Constants.nasaMediaSearchAPIPath
    }
    
    let parameters: Parameters
    private init(parameters: Parameters) {
        self.parameters = parameters
    }
}

extension NasaMediaLibraryRequest {
    /**
     * static function to form the request
     * parameter site - path of the request
     * return NasaMediaLibraryRequest - request to be sent for the apis
     */
    static func from(site: String) -> NasaMediaLibraryRequest {
        let defaultParameters = [Constants.mediaTypeParameter: Constants.mediaTypeParameterValue]
        let parameters = [Constants.searchApiParameter: "\(site)"].merging(defaultParameters, uniquingKeysWith: +)
        return NasaMediaLibraryRequest(parameters: parameters)
    }
}
