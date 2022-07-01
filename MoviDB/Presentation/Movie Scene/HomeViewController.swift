//
//  HomeViewController.swift
//  MoviDB
//
//  Created by Nitesh Singh on 28/06/22.
//

import Foundation
import UIKit
import Combine

final class HomeViewController: UIViewController, UICollectionViewDelegate, HomeBaseCoordinated {
    var coordinator: HomeBaseCoordinator?
    
    //MARK: Properties
    
    typealias DataSource = UICollectionViewDiffableDataSource<MovieType, Movie>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<MovieType, Movie>
    var datasource: DataSource!
    var viewModel: HomeViewModel
    private var cancellables = Set<AnyCancellable>()
    private var snapshot = Snapshot()
    
    private lazy var collectionView: UICollectionView = {
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: generateCompositionalLayout())
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    //MARK: Initializer
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        registerViews()
        setup()
        setupBindings()
        setupDatasource()
        viewModel.fetchMovies(with: .nowPlaying)
        viewModel.fetchMovies(with: .popular)
        viewModel.fetchMovies(with: .topRated)
        viewModel.fetchMovies(with: .upcoming)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //navigationController?.navigationBar.barStyle = .black
        //navigationController?.backgroundColor(Theme.with(color: .defaultBackgoundColor))
    }
    
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
    
    func setupBindings() {
        viewModel.movies.sink(receiveCompletion: { (completion) in
            
        }, receiveValue: { (movies) in
            self.updateSections(with: movies.0, section: movies.1)
        })
            .store(in: &cancellables)
    }
    
    func generateCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (section, env) -> NSCollectionLayoutSection? in
            
            guard let section = MovieType(rawValue: section) else { fatalError("Unknown section") }
            switch section {
                case .nowPlaying: return CollectionLayoutGenerator.generateLayoutForNowPlayingCell()
                default: return CollectionLayoutGenerator.generateLayoutForNormalMovieCell()
            }
        }
    }
}

extension HomeViewController {
    
    func registerViews() {
        collectionView.register(LargeMovieCell.self, forCellWithReuseIdentifier: LargeMovieCell.large_movie_cell_reuse_identifier)
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.movie_cell_reuse_identifier)
        collectionView.register(HeaderView.self,
                                forSupplementaryViewOfKind: HeaderView.sectionHeaderElementKind,
                                withReuseIdentifier: HeaderView.reuseIdentifier)
        collectionView.delegate = self
    }
    
    func updateSections(with movies: [Movie], section: MovieType) {
        
        snapshot.appendSections([section])
        snapshot.appendItems(movies, toSection: section)
        datasource.apply(snapshot, animatingDifferences: true)
    }
    
    func setupDatasource() {
        
        datasource = DataSource(collectionView: collectionView, cellProvider: {
            (collectionView, indexPath, movie) in
            
            guard let section = MovieType(rawValue: indexPath.section) else { fatalError("Unknown section") }
            
            switch section {
                case .nowPlaying:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LargeMovieCell.large_movie_cell_reuse_identifier, for: indexPath) as! LargeMovieCell
                    let viewModel = MovieViewModel(with: movie)
                    cell.viewModel = viewModel
                    viewModel.publish()
                    return cell
                    
                default:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.movie_cell_reuse_identifier, for: indexPath) as! MovieCell
                    let viewModel = MovieViewModel(with: movie)
                    cell.viewModel = viewModel
                    viewModel.publish()
                    return cell
            }
            
        })
        
        datasource.supplementaryViewProvider = { (collectionView, kind, indexPath) -> UICollectionReusableView? in
            
            guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.reuseIdentifier, for: indexPath) as? HeaderView else {
                fatalError()
            }
            
            let currentSnapshot = self.datasource.snapshot()
            let section = currentSnapshot.sectionIdentifiers[indexPath.section]
            supplementaryView.headerLabel.text = section.getTitle()
            
            return supplementaryView
        }
    }
}
