//
//  MovieSearchInteractor.swift
//  MovieSearch
//
//  Created by Mac on 7/14/21.
//

import Foundation

class MovieSearchInteractor: MovieSearchInputInteractorProtocol {
    
    weak var presenter: MovieSearchOutputInteractorProtocol?
    
    init() {
        
    }
    
    func makeSearchMovieRequest(name: String) {
        SearchMovieRequest(movieName: name).response(completion: {  [weak self] (result) in
            switch result {
            case .success(let response):
                self?.presenter?.onSearchMoviesSuccess(response: response)
                break
            case .failure(let error):
                self?.presenter?.onSearchMoviesError(error: error)
                break
            }
        })
    }

    
}
