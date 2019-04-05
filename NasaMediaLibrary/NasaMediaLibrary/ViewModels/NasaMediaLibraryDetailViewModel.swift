//
//  NasaMediaLibraryDetailViewModel.swift
//  NasaMediaLibrary
//
//  Created by Dharamshi, Lopa D on 4/4/19.
//  Copyright © 2019 Dharamshi Lopa D. All rights reserved.
//

import Foundation

class NasaMediaLibraryDetailViewModel {
    
    var detailModel:NasaMediaLibraryCollectionItem

    init(detailModel:NasaMediaLibraryCollectionItem){
        self.detailModel = detailModel
    }
    
    lazy var detailViewRowCount:Int = {
        return Constants.detailsRowCount
    }()
    
    func getTitle()->String? {
        guard let mediaLibraryData = detailModel.mediaLibraryModels.first else{
            return nil
        }
        
        return mediaLibraryData.title
    }
    
    func getDescription()->String? {
        guard let mediaLibraryData = detailModel.mediaLibraryModels.first else{
            return nil
        }
        
        return mediaLibraryData.description
    }
    
    func getDate()->String? {
        guard let mediaLibraryData = detailModel.mediaLibraryModels.first else{
            return nil
        }
        
        if let formattedDate = mediaLibraryData.date.getFormattedDate(){
            return formattedDate
        }
        return nil
    }
    
    func getImageURL()->String? {
        guard let mediaLibraryItemLink = detailModel.links.first else{
            return nil
        }
        return mediaLibraryItemLink.href
    }

}
