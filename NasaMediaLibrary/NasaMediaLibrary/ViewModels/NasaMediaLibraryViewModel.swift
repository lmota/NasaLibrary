//
//  NasaMediaLibraryViewModel.swift
//  NasaMediaLibrary
//
//  Created by Dharamshi, Lopa D on 4/2/19.
//  Copyright © 2019 Dharamshi Lopa D. All rights reserved.
//

import Foundation

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
    
    func fetchMediaLibraryCollectionItems() {
        
        guard !isFetchInProgress, !hasReachedMaxPageLimit else {
            return
        }
        
        isFetchInProgress = true
        
        requestManager.fetchModerators(with: request, page: currentPage) { result in
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
                    
                    if response.mediaLibraryCollection.mediaLibraryCollectionLinks.filter({$0.prompt == "Next"}).first == nil {
                        self.hasReachedMaxPageLimit = true
                    }
                    
                    if self.currentPage > 1 {
                        let indexPathsToReload = self.calculateIndexPathsToReload(from: response.mediaLibraryCollection.mediaLibraryCollectionItems)
                        self.delegate?.onFetchCompleted(with: indexPathsToReload)
                    } else {
                        self.delegate?.onFetchCompleted(with: .none)
                    }
                }
            }
        }
    }
    

    func calculateIndexPathsToReload(from newMediaLibraryCollectionItems: [NasaMediaLibraryCollectionItem]) -> [IndexPath]{
        let startIndex = mediaLibraryCollectionItems.count - newMediaLibraryCollectionItems.count
        let endIndex = startIndex + newMediaLibraryCollectionItems.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}
