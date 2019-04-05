//
//  Constants.swift
//  NasaMediaLibrary
//
//  Created by Dharamshi, Lopa D on 4/4/19.
//  Copyright © 2019 Dharamshi Lopa D. All rights reserved.
//

import Foundation
import UIKit

struct Constants{
    
    static let imageViewCornerRadius = 5.0
    static let backgroundColor = UIColor(red:0.925, green: 1.0, blue: 1.0, alpha: 1)
    static let serverDateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    static let desiredDateFormat = "EEEE, MMM d, yyyy"
    static let timeZone = "UTC"
    static let detailsRowCount = 1
    static let nasaMediaAPIURL = "https://images-api.nasa.gov/"
    static let nasaMediaSearchAPIPath = "search"
    static let pageParameter = "page"
    static let mediaTypeParameter = "media_type"
    static let mediaTypeParameterValue = "image"
    static let searchApiParameter = "q"
}
