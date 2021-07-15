//
//  Route.swift
//  MovieSearch
//
//  Created by Mac on 7/14/21.
//

import Foundation

enum APIRoute {
    case searchMovies
}

extension APIRoute {
    
    private var baseUrl: String {
        return Constant.MOVIE_DB_BASE_PATH
    }
    
    private var apiEndPoint: String {
        return "\(baseUrl)/\(urlPath)?api_key=\(Constant.API_KEY)"
    }
    
    private var urlPath: String {
        switch self {
        case .searchMovies:
            return "search/movie"
        }
    }
    
    var url: URL {
        return URL(string: apiEndPoint)!
    }
    
    var asRoute: Route {
        switch self {
        case .searchMovies:
            return Route.getRoute(path: apiEndPoint)
        }
    }
    
}
