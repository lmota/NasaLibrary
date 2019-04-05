//
//  NasaMediaLibraryViewModel.swift
//  NasaMediaLibrary
//
//  Created by Dharamshi, Lopa D on 4/2/19.
//  Copyright © 2019 Dharamshi Lopa D. All rights reserved.
//

import Foundation

// protocol declaration for the fetch completion functions
protocol NasaLibraryListViewModelDelegate: class {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onFetchFailed(with reason: String)
}

class NasaMediaLibraryViewModel {
    
    private weak var delegate: NasaLibraryListViewModelDelegate?
    private var mediaLibraryCollectionItems: [NasaMediaLibraryCollectionItem] = []
    
    private var currentPage = 0
    private var total = 0
    private var isFetchInProgress = false
    private var hasReachedMaxPageLimit = false
    
    var requestManager:NasaMediaLibraryRequestManager = NasaMediaLibraryRequestManager()
    var request:NasaMediaLibraryRequest
    
    init(delegate:NasaLibraryListViewModelDelegate, request:NasaMediaLibraryRequest)
    {
        self.delegate = delegate
        self.request = request
    }
    
    var totalCount: Int {
        return total
    }
    
    var currentCount: Int {
        return mediaLibraryCollectionItems.count
    }
    
    func nasaMediaLibraryModel(at index: Int) -> NasaMediaLibraryCollectionItem {
        return mediaLibraryCollectionItems[index]
    }
    
    func getTitle(at index:Int)->String? {
        guard index < mediaLibraryCollectionItems.count else { return nil }
        
        let collectionItem = mediaLibraryCollectionItems[index]
        guard let mediaLibraryData = collectionItem.mediaLibraryModels.first else{
            return nil
        }
        
        return mediaLibraryData.title
    }
    
    func getDescription(st index:Int)->String? {
        guard index < mediaLibraryCollectionItems.count else { return nil }
        
        let collectionItem = mediaLibraryCollectionItems[index]
        guard let mediaLibraryData = collectionItem.mediaLibraryModels.first else{
            return nil
        }
        
        return mediaLibraryData.description
    }
    
    func getDate(at index:Int)->String? {
        guard index < mediaLibraryCollectionItems.count else { return nil }
        
        let collectionItem = mediaLibraryCollectionItems[index]
        guard let mediaLibraryData = collectionItem.mediaLibraryModels.first else{
            return nil
        }
        
        if let formattedDate = mediaLibraryData.date.getFormattedDate(){
            return formattedDate
        }
        return nil
    }
    
    func getImageURL(at index:Int)->String? {
        
        guard index < mediaLibraryCollectionItems.count else { return nil }
        
        let collectionItem = mediaLibraryCollectionItems[index]
        guard let mediaLibraryItemLink = collectionItem.links.first else{
            return nil
        }

        return mediaLibraryItemLink.href
    }
    
    // fetching the media images from backend
    func fetchMediaLibraryCollectionItems() {
        
        // since this method is called multiple times when user scrolls to the bottom of the table, we need to ensure that a fetch is not in pogress and we have not reached maximum page limit
        guard !isFetchInProgress, !hasReachedMaxPageLimit else {
            return
        }
        
        isFetchInProgress = true
        
        requestManager.fetchNasaMediaImages(with: request, page: currentPage) { result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isFetchInProgress = false
                    self.delegate?.onFetchFailed(with: error.reason)
                }
            case .success(let response):
                DispatchQueue.main.async {
                    
                    self.currentPage += 1
                    self.isFetchInProgress = false
                   
                    self.mediaLibraryCollectionItems.append(contentsOf: response.mediaLibraryCollection.mediaLibraryCollectionItems)
                    self.total = self.mediaLibraryCollectionItems.count
                    
                    // we check the next link for the current response. if its not present, we have reached the max page limit
                    if response.mediaLibraryCollection.mediaLibraryCollectionLinks.filter({$0.prompt == "Next"}).first == nil {
                        self.hasReachedMaxPageLimit = true
                    }
                    
                    // if current page is greater than one then we want to insert the additional items
                    if self.currentPage > 1 {
                        let indexPathsToReload = self.calculateIndexPathsToReload(from: response.mediaLibraryCollection.mediaLibraryCollectionItems)
                        self.delegate?.onFetchCompleted(with: indexPathsToReload)
                    } else { // if current page is first page then we need to reload the table
                        self.delegate?.onFetchCompleted(with: .none)
                    }
                }
            }
        }
    }
    
    // utility method to compute the index paths that need to be reloaded
    private func calculateIndexPathsToReload(from newMediaLibraryCollectionItems: [NasaMediaLibraryCollectionItem]) -> [IndexPath]{
        let startIndex = mediaLibraryCollectionItems.count - newMediaLibraryCollectionItems.count
        let endIndex = startIndex + newMediaLibraryCollectionItems.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}
