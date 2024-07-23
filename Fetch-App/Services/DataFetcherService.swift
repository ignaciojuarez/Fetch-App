//
//  DataFetcherService.swift
//  Fetch-App
//
//  Created by Ignacio Juarez on 7/22/24.
//

import Foundation

/// A generic service for fetching and decoding data from a URL
class DataFetcherService<T: Decodable> {
    private let decoder: JSONDecoder
    private let session: URLSession
    
    /// Initializes a new data fetcher service with optional custom decoder and session
    /// - Parameters:
    ///   - decoder: JSON decoder  for decoding response. Defaults to `JSONDecoder()`
    ///   - session: URLSession for making requests. Defaults to `URLSession.shared`
    init(decoder: JSONDecoder = JSONDecoder(), session: URLSession = URLSession.shared) {
        self.decoder = decoder
        self.session = session
    }
    
    /// Fetches and decodes JSON data from a specified URL
    /// - Parameters:
    ///   - url: The URL to fetch data from
    ///   - headers: Optional HTTP headers to include in the request
    /// - Returns: A decoded object of type T
    /// - Throws: Error if fetching or decoding fails
    func fetchData(from url: URL, headers: [String: String]? = nil) async throws -> T {
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        
        let (data, response) = try await session.data(for: request)
    
        // Ensure the HTTP response status code is 200 (success)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NSError(domain: "com.DataFetcherService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid HTTP response"])
        }
        
        // Decode the JSON data to the specified Decodable type T
        return try decoder.decode(T.self, from: data)
    }
}
