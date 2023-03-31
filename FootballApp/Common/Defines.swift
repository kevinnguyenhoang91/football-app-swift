//
//  Defines.swift
//  FootballApp
//
//  Created by Kha Nguyễn on 30/03/2023.
//

import Foundation
import Combine

public struct Defines {
    static let baseURL = "https://jmde6xvjr4.execute-api.us-east-1.amazonaws.com"
    static let dateFormatString = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    static let displayDateFormatString = "dd/MM/yyyy - h:mm a"
}

typealias ShortOutput = URLSession.DataTaskPublisher.Output

extension URLSession {
    func dataTaskPublisher(for url: URL,
                           cachedResponseOnError: Bool) -> AnyPublisher<ShortOutput, Error> {
        
        return self.dataTaskPublisher(for: url)
            .tryCatch { [weak self] (error) -> AnyPublisher<ShortOutput, Never> in
                guard cachedResponseOnError,
                      let urlCache = self?.configuration.urlCache,
                      let cachedResponse = urlCache.cachedResponse(for: URLRequest(url: url))
                else {
                    throw error
                }
                
                return Just(ShortOutput(
                    data: cachedResponse.data,
                    response: cachedResponse.response
                )).eraseToAnyPublisher()
            }.eraseToAnyPublisher()
    }
}
