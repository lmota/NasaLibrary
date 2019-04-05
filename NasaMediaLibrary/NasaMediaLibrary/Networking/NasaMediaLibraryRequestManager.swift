//
//  NasaMediaLibraryRequestManager.swift
//  NasaMediaLibrary
//
//  Created by Dharamshi, Lopa D on 4/2/19.
//  Copyright © 2019 Dharamshi Lopa D. All rights reserved.
//

import Foundation

enum Result<T, U: Error> {
    case success(T)
    case failure(U)
}

class NasaMediaLibraryRequestManager{
    
    private lazy var baseURL: URL? = {
        return URL(string: Constants.nasaMediaAPIURL)
    }()
    
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    /**
     * fetching Media images from nasa
     * parameters : request - urlRequest, page - requested page number, completion - closure to execute once the response is received
     * return - nothing
     */
    func fetchNasaMediaImages(with request: NasaMediaLibraryRequest, page: Int,
                         completion: @escaping (Result<NasaMediaLibraryPageResponse, NasaMediaResponseError>) -> Void) {
        guard let baseURL = baseURL else{
            return
        }
        let urlRequest = URLRequest(url: baseURL.appendingPathComponent(request.path))
        
        // current page is initialized to zero, hence adding 1 to start requesting pages from 1
        let parameters = [Constants.pageParameter: "\(page+1)"].merging(request.parameters, uniquingKeysWith: +)
        
        let encodedURLRequest = urlRequest.encode(with: parameters)
        
        session.dataTask(with: encodedURLRequest, completionHandler: { data, response, error in
            
            guard
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.hasSuccessStatusCode,
                let data = data
                else {
                    completion(Result.failure(NasaMediaResponseError.network))
                    return
            }
            
            do {
                
               let decodedResponse = try JSONDecoder().decode(NasaMediaLibraryPageResponse.self, from: data)
                completion(Result.success(decodedResponse))

            } catch let error {
                Logger.logInfo(error.localizedDescription)
                completion(Result.failure(NasaMediaResponseError.decoding))
            }
            
        }).resume()
    }
    
    
}
