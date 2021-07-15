//
//  ViewController.swift
//  MovieSearch
//
//  Created by Mac on 7/14/21.
//

import UIKit

class SearchViewController: UIViewController {
    private var moviesResult: [Movie] = []
    var presenter: MovieSearchPresenterProtocol?
    var imgCache : NSCache<NSURL, UIImage> = NSCache()

    lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 16
        let itemWidth: CGFloat = (UIScreen.main.bounds.width - (3 * spacing))
        let itemHeight: CGFloat = itemWidth * (1/2)
        layout.sectionHeadersPinToVisibleBounds = true
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.sectionInset = UIEdgeInsets.init(top: spacing * 2, left: spacing * 2, bottom: spacing * 2, right: spacing * 2)
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initVC()
        setUI()
    }
    
    private func initVC() {
        let presenter: MovieSearchPresenterProtocol & MovieSearchOutputInteractorProtocol = MovieSearchPresenter()
        let interactor: MovieSearchInputInteractorProtocol = MovieSearchInteractor()
        self.presenter = presenter
        self.presenter?.view = self
        self.presenter?.interactor = interactor
        interactor.presenter = presenter
    }
    
    private func setUI() {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search"
        navigationItem.searchController = search
        
        view.addSubview(collectionView)
        collectionView.register(UINib(nibName: "MovieCell", bundle: nil), forCellWithReuseIdentifier: "MovieCell")
        collectionView.backgroundColor = UIColor.white
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        ])
    }
    
    private func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = moviesResult[indexPath.row]
        cell.configure(movie: movie)
        let displayImage = cell.imgView
        if let poster = imgCache.object(forKey: movie.fullPosterPath as NSURL) {
            displayImage?.image = poster
        } else {
            getDataFromUrl(url: movie.fullPosterPath) { data, response, error in
                guard let data = data, error == nil else { return }
                print("Download Finished: " + (response?.suggestedFilename)!)
                DispatchQueue.main.async() {
                    let fetchedImg = UIImage(data: data)
                    displayImage?.image = fetchedImg
                    if fetchedImg != nil {
                        self.imgCache.setObject(fetchedImg!, forKey: movie.fullPosterPath as NSURL)
                    }
                }
            }
        }

        return cell
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        presenter?.searchMovie(searchText: text)
    }
}

extension SearchViewController: MovieSearchVCProtocol {
    func showSearchResult(movies: [Movie]) {
        moviesResult.removeAll()
        moviesResult.append(contentsOf: movies)
        collectionView.reloadData()
    }
}
