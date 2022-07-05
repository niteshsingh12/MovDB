//
//  HomeViewController.swift
//  MoviDB
//
//  Created by Nitesh Singh on 28/06/22.
//

import Foundation
import UIKit
import Combine

final class HomeViewController: UIViewController, HomeBaseCoordinated {
    
    //MARK: Properties
    
    typealias DataSource = UICollectionViewDiffableDataSource<MovieType, Movie>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<MovieType, Movie>
    var datasource: DataSource!
    var viewModel: HomeViewModel
    var imageLoader: ImageLoaderProtocol
    private var cancellables = Set<AnyCancellable>()
    private var snapshot = Snapshot()
    var coordinator: HomeBaseCoordinator?
    var isErrorDisplayed = false
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: generateCompositionalLayout())
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    //MARK: Initializer
    
    init(viewModel: HomeViewModel, imageLoader: ImageLoaderProtocol) {
        self.viewModel = viewModel
        self.imageLoader = imageLoader
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerViews()
        setup()
        setupBindings()
        setupDatasource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: Setup
    
    func setup() {
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    //MARK: Helper Methods
    
    func setupBindings() {
        viewModel.movies.sink(receiveCompletion: { (completion) in
            
        }, receiveValue: { (movies) in
            self.updateSections(with: movies.0, section: movies.1)
        })
            .store(in: &cancellables)
        
        /*
         Observes state and if request is failed, popup is shown. As there are 4 concurrent requests, if any one is failed popup will be shown
         */
        viewModel.state.sink(receiveValue: { (state) in
            
            switch state {
                case .finishedWithError(let error):
                    
                    if !self.isErrorDisplayed {
                        DispatchQueue.main.async {
                            self.showAlertForError(error: error)
                        }
                        self.isErrorDisplayed = true
                    }
                    
                default: ()
            }
        })
            .store(in: &cancellables)
        
        fetchDataSource()
    }
    
    func fetchDataSource() {
        viewModel.fetchMovies(with: .nowPlaying)
        viewModel.fetchMovies(with: .popular)
        viewModel.fetchMovies(with: .topRated)
        viewModel.fetchMovies(with: .upcoming)
    }
    
    func updateSections(with movies: [Movie], section: MovieType) {
        snapshot.appendSections([section])
        snapshot.appendItems(movies, toSection: section)
        datasource.apply(snapshot, animatingDifferences: true)
    }
}

extension HomeViewController {
    
    // MARK: - Alert Methods
    
    func showAlertForError(error: Error) {
        Alert.present(title: "Information", message: error.localizedDescription, actions: .retry(handler: {
            self.retryRequest()
        }), .okay, from: self)
    }
    
     /*
      Request retrier
     */
    func retryRequest() {
        fetchDataSource()
    }
}
