//
//  NasaMediaLibraryTests.swift
//  NasaMediaLibraryTests
//
//  Created by Dharamshi, Lopa D on 4/2/19.
//  Copyright © 2019 Dharamshi Lopa D. All rights reserved.
//

import XCTest

@testable import NasaMediaLibrary

class NasaMediaLibraryTests: XCTestCase {
    
    private var viewModelTest:NasaMediaLibraryViewModel?
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        guard viewModelTest == nil else {return}

        let viewController = NasaMediaLibraryViewController()
        viewModelTest = NasaMediaLibraryViewModel(delegate:viewController, request:NasaMediaLibraryRequest.from(site:"Lunar"))
        let response = "{\"collection\": {\"href\": \"https://images-api.nasa.gov/search?media_type=image&q=apollo+11&page=4&description=moon+landing\",\"version\": \"1.0\",\"items\": [{\"href\": \"https://images-assets.nasa.gov/image/S69-39962/collection.json\",\"data\": [{\"description\": \"S69-39962 (16 July 1969) --- The huge, 363-feet\",\"title\":\"Liftoff - Apollo XI - Lunar Landing Mission - KSC\",\"date_created\": \"1969-07-16T00:00:00Z\",\"center\": \"JSC\"}],\"links\": [{\"href\": \"https://images-assets.nasa.gov/image/S69-39962/S69-39962~thumb.jpg\",\"render\": \"image\",\"rel\": \"preview\"}]}],\"links\": [{\"href\": \"https://images-api.nasa.gov/search?page=3&description=moon+landing&media_type=image&q=apollo+11\",\"prompt\": \"Previous\",\"rel\": \"prev\"}],\"metadata\":{\"total_hits\": 344}}}"
        
        guard let dataResponse = response.data(using: .utf8) else { return }
        
        guard let decodedResponse:NasaMediaLibraryPageResponse = try? JSONDecoder().decode(NasaMediaLibraryPageResponse.self, from:dataResponse) else { return }
        
        viewModelTest?.mediaLibraryCollectionItems = decodedResponse.mediaLibraryCollection.mediaLibraryCollectionItems

    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModelTest = nil
    }

    func testListViewModelGetTitle() {
 
        let actualTitle = viewModelTest?.getTitle(at:0)
        let desiredTitle = "Liftoff - Apollo XI - Lunar Landing Mission - KSC"
        XCTAssertEqual(actualTitle, desiredTitle)
    }
    
    func testListViewModelGetTitleAtInvalidIndex() {
        
        let actualTitle = viewModelTest?.getTitle(at:1)
        XCTAssertNil(actualTitle)
    }

    func testListViewModelGetDescription() {
        
        let actualDescription = viewModelTest?.getDescription(at:0)
        let desiredDescription = "S69-39962 (16 July 1969) --- The huge, 363-feet"
        XCTAssertEqual(actualDescription, desiredDescription)
    }
    
    func testListViewModelGetDescriptionAtInvalidIndex() {
        
        let actualDescription = viewModelTest?.getDescription(at:1)
        XCTAssertNil(actualDescription)
    }
    
    func testListViewModelGetDate() {
        let actualDate = viewModelTest?.getDate(at:0)
        let desiredDate = "Wednesday, Jul 16, 1969"
        XCTAssertEqual(actualDate, desiredDate)
    }
    
    func testListViewModelGetDateAtInvalidIndex() {
        
        let actualDate = viewModelTest?.getDate(at:1)
        XCTAssertNil(actualDate)
    }
    
    func testListViewModelGetImageURL() {
        let actualImageURL = viewModelTest?.getImageURL(at:0)
        let desiredImageURL = "https://images-assets.nasa.gov/image/S69-39962/S69-39962~thumb.jpg"
        XCTAssertEqual(actualImageURL, desiredImageURL)
    }
    
    func testListViewModelGetImageURLAtInvalidIndex() {
        
        let actualImageURL = viewModelTest?.getImageURL(at:1)
        XCTAssertNil(actualImageURL)
    }
    
    
}
