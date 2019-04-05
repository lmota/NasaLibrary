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
    private lazy var baseURL: URL = {
        return URL(string: Constants.nasaMediaAPIURL)!
    }()
    
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func fetchModerators(with request: NasaMediaLibraryRequest, page: Int,
                         completion: @escaping (Result<NasaMediaLibraryPageResponse, NasaMediaResponseError>) -> Void) {

        let urlRequest = URLRequest(url: baseURL.appendingPathComponent(request.path))
        
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
