//
//  MovieDetailViewController.swift
//  MoviDB
//
//  Created by Nitesh Singh on 30/06/22.
//

import Foundation
import UIKit
import Combine

final class MovieDetailViewController: UIViewController, HomeBaseCoordinated {
    
    //MARK: UI Properties
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        scrollView.bounces = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon_img_unavailable")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var fillerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.font = .detailTitle
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var ratingsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white.withAlphaComponent(0.5)
        label.textAlignment = .center
        label.font = .detailContent
        return label
    }()
    
    lazy var detailsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    lazy var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white.withAlphaComponent(0.5)
        label.textAlignment = .center
        label.font = .detailContent
        return label
    }()
    
    lazy var runtimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white.withAlphaComponent(0.5)
        label.textAlignment = .center
        label.font = .detailContent
        return label
    }()
    
    lazy var revenueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white.withAlphaComponent(0.5)
        label.textAlignment = .center
        label.font = .detailContent
        return label
    }()
    
    lazy var storyLineLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white.withAlphaComponent(0.4)
        label.text = "Story Line"
        label.font = .detailHeader
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.font = .detailDescription
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(section: CollectionLayoutGenerator.generateLayoutForSimilarCell()))
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(.back, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()
    
    //MARK: Properties
    
    typealias Datasource = UICollectionViewDiffableDataSource<MovieDetailViewModel.Section, AnyHashable>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<MovieDetailViewModel.Section, AnyHashable>
    var datasource: Datasource!
    private var snapshot = Snapshot()
    
    private var cancellables = Set<AnyCancellable>()
    var viewModel: MovieDetailViewModel
    private var movie: Movie
    var imageLoader: ImageLoaderProtocol = ImageLoader()
    private var isGardientAdded = false
    var coordinator: HomeBaseCoordinator?
    
    //MARK: Initializer
    
    init(viewModel: MovieDetailViewModel, imageLoader: ImageLoaderProtocol, movie: Movie) {
        self.viewModel = viewModel
        self.movie = movie
        self.imageLoader = imageLoader
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: View Lifecycle
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerViews()
        setupDatasource()
        setup()
        setupBindings()
        
        ///Download image in Task to avoid making container method as async
        Task.detached {
            await self.downloadImage()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !isGardientAdded {
            isGardientAdded = true
            setGradientColour()
        }
    }
    
    //MARK: Methods
    
    func setupBindings() {
        
        /*
         Observe movie detail publisher to update details of particular movie
         */
        viewModel.movieDetail.sink(receiveCompletion: { (completion) in
            
        }, receiveValue: { [weak self] (movie) in
            self?.movie = movie
            self?.initializeViewsWithData()
            self?.updateSections(with: [])
        })
            .store(in: &cancellables)
        
        /*
         Observes similar movies request and updates section once received
         */
        viewModel.similarMovies.sink(receiveCompletion: { (completion) in
            
        }, receiveValue: { [weak self] (similarMovies) in
            self?.updateSections(with: similarMovies)
        })
            .store(in: &cancellables)
        
        /*
         Observes state and if request is failed, popup is shown
         */
        viewModel.state.sink(receiveValue: { (state) in
            
            switch state {
                case .finishedWithError(let error):
                    DispatchQueue.main.async {
                        self.showAlertForError(error: error)
                    }
                default: ()
            }
        })
            .store(in: &cancellables)
        
        fetchDataSource()
    }
    
    func fetchDataSource() {
        viewModel.fetchMovieDetail(for: String(movie.id))
        viewModel.fetchSimilarMovies(for: String(movie.id))
    }
    
    private func setup() {
        
        view.addSubview(scrollView)
        view.insertSubview(coverImageView, belowSubview: scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(containerStackView)
        
        containerStackView.addArrangedSubview(fillerView)
        containerStackView.addArrangedSubview(titleStackView)
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(ratingsLabel)
        titleStackView.addArrangedSubview(detailsStackView)
        detailsStackView.addArrangedSubview(releaseDateLabel)
        detailsStackView.addArrangedSubview(runtimeLabel)
        detailsStackView.addArrangedSubview(revenueLabel)
        containerStackView.addArrangedSubview(storyLineLabel)
        containerStackView.addArrangedSubview(descriptionLabel)
        containerStackView.addArrangedSubview(collectionView)
        
        view.insertSubview(backButton, aboveSubview: scrollView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: view.topAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            coverImageView.heightAnchor.constraint(equalToConstant: 400),
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant:  20),
            
            titleStackView.trailingAnchor.constraint(equalTo: containerStackView.trailingAnchor),
            titleStackView.leadingAnchor.constraint(equalTo: containerStackView.leadingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 400),
            collectionView.trailingAnchor.constraint(equalTo: containerStackView.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: containerStackView.leadingAnchor),
            
            backButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            
            fillerView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        self.titleLabel.text = self.movie.original_title
        self.descriptionLabel.text = self.movie.overview
    }
    
    private func initializeViewsWithData() {
        DispatchQueue.main.async {
            self.releaseDateLabel.text =  "📆 " + String(self.movie.release_date.prefix(4))
            self.ratingsLabel.text = "⭐️ " + String(self.movie.vote_average) + "        " + self.movie.getGenres()
            if let runtime = self.movie.runtime {
                self.runtimeLabel.text = "📽 " + runtime.runTimeString
            }
            if let revenue = self.movie.revenue {
                self.revenueLabel.text = "💵 " + revenue.currencyInUSD()
            }
        }
    }
    
    func setGradientColour() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.0, 0.4, 1.0]
        gradientLayer.frame = scrollView.bounds
        scrollView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    @MainActor private func downloadImage() async {
        let absolutePath = AppConstants.imageBaseURL500 + movie.poster_path!
        async let image = imageLoader.image(from: URL(string: absolutePath)!)
        coverImageView.image = try? await image
    }
    
    @MainActor func updateSections(with movies: [Movie]) {
        if let casts = movie.credits?.cast, !snapshot.sectionIdentifiers.contains(.cast) {
            snapshot.appendSections([.cast])
            snapshot.appendItems(casts, toSection: .cast)
            datasource.apply(snapshot, animatingDifferences: true)
        } else if movies.count > 0, !snapshot.sectionIdentifiers.contains(.similar) {
            snapshot.appendSections([.similar])
            snapshot.appendItems(movies, toSection: .similar)
            datasource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    @objc func didTapBackButton() {
        coordinator?.moveBackToHomePage()
    }
}

extension MovieDetailViewController {
    
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
