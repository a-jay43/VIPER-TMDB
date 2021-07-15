//
//  MovieSearchProtocols.swift
//  MovieSearch
//
//  Created by Mac on 7/14/21.
//

import Foundation

protocol MovieSearchVCProtocol: class {
    var presenter: MovieSearchPresenterProtocol? { get set }
    func showSearchResult(movies: [Movie])
}

protocol MovieSearchInputInteractorProtocol: class {
    var presenter: MovieSearchOutputInteractorProtocol? { get set }
    func makeSearchMovieRequest(name: String)
}

protocol MovieSearchOutputInteractorProtocol: class {
    func onSearchMoviesSuccess(response: MoviesResponse)
    func onSearchMoviesError(error: APIError)
}

protocol MovieSearchPresenterProtocol: class {
    var view: MovieSearchVCProtocol? { get set }
    var interactor: MovieSearchInputInteractorProtocol? { get set }
    func searchMovie(searchText: String)
}
