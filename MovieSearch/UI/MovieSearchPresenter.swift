//
//  MovieSearchPresenter.swift
//  MovieSearch
//
//  Created by Mac on 7/14/21.
//

import Foundation

class MovieSearchPresenter: MovieSearchPresenterProtocol {
    weak var view: MovieSearchVCProtocol?
    var interactor: MovieSearchInputInteractorProtocol?
    private var movies: [Movie] = []
        
    func viewDidLoad() {
        
    }
    
    func viewWillAppear() {
        
    }
    
    func searchMovie(searchText: String) {
        let movieName = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        interactor?.makeSearchMovieRequest(name: movieName)
    }
}

extension MovieSearchPresenter: MovieSearchOutputInteractorProtocol {
    func onSearchMoviesSuccess(response: MoviesResponse) {
        self.movies.removeAll()
        let movies = response.results
        self.movies.append(contentsOf: movies)
        view?.showSearchResult(movies: self.movies)
    }
    
    func onSearchMoviesError(error: APIError) {
        print(error)
    }
}
