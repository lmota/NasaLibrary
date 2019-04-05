//
//  StringExtension.swift
//  NasaMediaLibrary
//
//  Created by Dharamshi, Lopa D on 4/4/19.
//  Copyright © 2019 Dharamshi Lopa D. All rights reserved.
//

import Foundation


extension String{
    
    func getFormattedDate() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.serverDateFormat
        
        let dateFormatterNew = DateFormatter()
        dateFormatterNew.dateFormat = Constants.desiredDateFormat
        dateFormatterNew.timeZone = TimeZone(abbreviation: Constants.timeZone) // check if this is needed
        if let date = dateFormatter.date(from: self){
            return dateFormatterNew.string(from: date)
        }
        
        return nil
    }
    
}
