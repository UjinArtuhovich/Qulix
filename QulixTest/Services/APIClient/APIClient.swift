//
//  APIClient.swift
//  QulixTest
//
//  Created by Ujin Artuhovich on 26.11.21.
//

import Foundation

class APiClinet {
    static let shared = APiClinet()
    
    private var task: URLSessionDataTask?
    
    func fetchSearchData(
        with request: String,
        completion: @escaping (Result<SearchResponse, CustomError>) -> Void
    ) {
        guard let url = URL(string: APIEndpoints.mainURL) else {
            completion(.failure(.apiError))
            return
        }
        
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        let queryItems = [
            URLQueryItem(name: APIQueryItems.apiKey, value: APIEndpoints.apiKey),
            URLQueryItem(name: APIQueryItems.cx, value: APIEndpoints.cx),
            URLQueryItem(name: APIQueryItems.q, value: request),
        ]
        urlComponents.queryItems = queryItems
        guard let finalURL = urlComponents.url else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        loadAndDecode(url: finalURL, completion: completion)
    }
    
    //MARK: Base function for request
    private func loadAndDecode<D: Decodable>(
        url: URL,
        completion: @escaping (Result<D, CustomError>) -> Void
    ) {
        if !InternetConnectionObserver.isInternetAvailable() {
            self.moveCompletionToMainThread(with: .failure(.noConnection), completion: completion)
            return
        }
        
        task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                self.moveCompletionToMainThread(with: .failure(.apiError), completion: completion)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, 200 ..< 300 ~= httpResponse.statusCode else {
                self.moveCompletionToMainThread(with: .failure(.invalidResponse), completion: completion)
                return
            }
            
            guard let data = data else {
                self.moveCompletionToMainThread(with: .failure(.noData), completion: completion)
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                let decodeResponse = try jsonDecoder.decode(D.self, from: data)
                self.moveCompletionToMainThread(with: .success(decodeResponse), completion: completion)
            } catch {
                self.moveCompletionToMainThread(with: .failure(.serializationError), completion: completion)
                return
            }
            
        }
        guard let task = task else {
            self.moveCompletionToMainThread(with: .failure(.serializationError), completion: completion)
            return
        }
        
        task.resume()
    }
    
    public func cancelTask() {
        guard let task = task else { return }
        
        task.cancel()
    }
    
    //MARK: function for returning to main thread
    private func moveCompletionToMainThread<D: Decodable>(with result: Result<D, CustomError>, completion: @escaping (Result<D, CustomError>) -> Void) {
        DispatchQueue.main.async {
            completion(result)
        }
    }
}
