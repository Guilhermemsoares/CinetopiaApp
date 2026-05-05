//
//  MovieService.swift
//  Cinetopia
//
//  Created by Guilherme Moreira Soares on 29/04/26.
//

import Foundation
import Alamofire

enum MovieServiceError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
}

struct MovieService {
    
    func getMovies() async throws -> [Movie] {
        
        let urlString = "https://my-json-server.typicode.com/alura-cursos/movie-api/movies"
        
        guard let url = URL(string: urlString) else {
            throw MovieServiceError.invalidURL
        }
        
        let request = AF.request(url)
        
        let dataTask = request.serializingDecodable([Movie].self)
        let data = await dataTask.response

        guard data.response?.statusCode == 200 else {
            throw MovieServiceError.invalidResponse
        }

        guard let movies = data.value else {
            throw MovieServiceError.decodingError
        }

        return movies
    }
}
