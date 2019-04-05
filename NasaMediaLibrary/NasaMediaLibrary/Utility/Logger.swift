//
//  Logger.swift
//  NasaMediaLibrary
//
//  Created by Dharamshi, Lopa D on 4/5/19.
//  Copyright © 2019 Dharamshi Lopa D. All rights reserved.
//

import Foundation

public struct Logger {
    
    /**
     print items to the console
     
     - parameter items:      items to print
     - parameter separator:  separator between items. Default is space" "
     - parameter terminator: a character inserted at the end of output.
     */
    
    public static func logInfo(_ text:String){
        #if DEBUG
            print(text)
        #endif
    }
}
