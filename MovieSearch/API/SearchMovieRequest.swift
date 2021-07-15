//
//  SearchMovieRequest.swift
//  MovieSearch
//
//  Created by Mac on 7/14/21.
//

import Foundation

class MoviesResponse: Codable {
    
    var page: Int = 1
    var totalResults: Int = 0
    var totalPages: Int = 0
    var results: [Movie] = []
    
    enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results
    }
    
}

class SearchMovieRequest: APIRequest<MoviesResponse> {
    
    private var page: Int = 1
    private var movieName: String = ""
    
    init(movieName: String) {
        self.movieName = movieName
        super.init(route: APIRoute.searchMovies.asRoute)

    }
    
    override func getParameters() -> [String : Any] {
        return [
           "query": self.movieName
        ]
    }
    
}
