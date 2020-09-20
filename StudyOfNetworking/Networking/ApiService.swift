//
//  ApiService.swift
//  StudyOfNetworking
//
//  Created by Macbook on 10.09.2020.
//  Copyright © 2020 Igor Simonov. All rights reserved.
//

import Foundation


class ApiService {
    
    private var dataTask: URLSessionDataTask?
    
    func getPopularMoviesData(completion: @escaping (Result<MoviesData, Error>) -> Void) {
        let popularMoviesURL = "https://api.themoviedb.org/3/movie/popular?api_key=a1dad0059ef992c181afd0a07f2385ee"
        
        guard let url = URL(string: popularMoviesURL) else { return }
        
        dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                completion(.failure(error))
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard response == response as? HTTPURLResponse else {
                print("Empty Response")
                return
            }
            
            guard let data = data else {
                print("Empty Data")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(MoviesData.self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(jsonData))
                }
                
            } catch let error {
                completion(.failure(error))
            }
        }
        dataTask?.resume()
    }
}
