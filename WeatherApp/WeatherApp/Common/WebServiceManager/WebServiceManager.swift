//
//  WebServiceManager.swift
//  WeatherApp
//
//  Created by Monikaa on 29/12/23.
//

import Foundation

class WebServiceManager {
    // @escaping is used here, because this is a background task.
    // @escaping captures data in memory.
    
    func getRequestData<T: Codable>(
        urlString: String,
        param: Data? = nil,
        httpMethod: HttpMethod,
        responseModel: T.Type,
        completion: @escaping(Result<T, Error>) -> Void
    ) {
        // Create URL
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.badURL))
            return
        }
        
        //Create URLRequest
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue(WebServiceConstant.applicationJSON, forHTTPHeaderField: WebServiceConstant.contentType)
        urlRequest.httpBody = param
        urlRequest.httpMethod = httpMethod.rawValue
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data else { 
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(NetworkError.noData))
                }
                return
            }
            do {
                
                // JSONDecoder() converts data to model
                let newData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(newData))
            }
            catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
