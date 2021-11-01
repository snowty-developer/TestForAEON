//
//  DataLoader.swift
//  TestForAEON
//
//  Created by Александр Зубарев on 30.10.2021.
//

import Foundation
import Metal


class DataLoadingFunction {
    
    func LoadPayments(token: String, completion: @escaping (Result<[Payment], Error>) -> Void) {
        let queryItem = [URLQueryItem(name: "token", value: token)]
        guard var urlComponents = URLComponents(string: "http://82.202.204.94/api-test/payments") else { return }
        urlComponents.queryItems = queryItem
        guard let url = urlComponents.url else { return }
        
        var request = URLRequest(url: url)
        request.addValue("12345", forHTTPHeaderField: "app-key")
        request.addValue("1", forHTTPHeaderField: "v")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data  else { return }
                do {
                    let payments = try JSONDecoder().decode(PaymentsFromJSON.self, from: data)
                    completion(.success(payments.response))
                } catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                    completion(.failure(jsonError))
                }
            }
        }.resume()
    }
    
    func SignIn(login: String, password: String, completion: @escaping (Result<TokenFromJSON, Error>) -> Void) {
        guard let url = URL(string: "http://82.202.204.94/api-test/login") else { return }
        var request = URLRequest(url: url)
        request.addValue("12345", forHTTPHeaderField: "app-key")
        request.addValue("1", forHTTPHeaderField: "v")
        request.httpMethod = "POST"
        
        let body = ["login": login, "password": password]
        guard let httpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else { return }
        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else { return }
                do {
                    let token = try JSONDecoder().decode(TokenFromJSON.self, from: data)
                    completion(.success(token))
                } catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                    completion(.failure(jsonError))
                }
            }
        }.resume()
    }
}
