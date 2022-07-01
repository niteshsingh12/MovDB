//
//  MovieCell.swift
//  MoviDB
//
//  Created by Nitesh Singh on 29/06/22.
//

import Foundation
import UIKit
import Combine

final class MovieCell: UICollectionViewCell {
    
    static let movie_cell_reuse_identifier = "movie-cell-reuse-identifier"
    
    lazy var thumbImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8.0
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var movieTitleLabel: VerticalAlignedLabel = {
        let label = VerticalAlignedLabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .left
        label.textColor = .label
        return label
    }()
    
    lazy var genreLabel: VerticalAlignedLabel = {
        let label = VerticalAlignedLabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.textAlignment = .left
        label.textColor = .secondaryLabel
        return label
    }()
    
    var viewModel: MovieViewModel! {
        didSet {
            setupBindings()
        }
    }
    
    var gradientLayer = CAGradientLayer()
    
    var imageURL = String()
    
    var imageLoader: ImageLoader? = DefaultImageLoader(manager: DefaultNetworkManager(URLSession(configuration: .default)))
    private var cancellables = Set<AnyCancellable>()
    
    func injectDependencies(imageLoader: ImageLoader) {
        self.imageLoader = imageLoader
        //self.viewModel = viewModel
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = thumbImageView.frame
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //imageLoader?.cancelLoad(imageURL)
        thumbImageView.image = nil
    }
    
    private func setup() {
        let subviews = [thumbImageView, movieTitleLabel, genreLabel]
        
        subviews.forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            thumbImageView.topAnchor.constraint(equalTo: self.topAnchor),
            thumbImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            thumbImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            movieTitleLabel.heightAnchor.constraint(equalToConstant: 30),
            movieTitleLabel.topAnchor.constraint(equalTo: self.thumbImageView.bottomAnchor, constant: 0),
            movieTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            movieTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            genreLabel.heightAnchor.constraint(equalToConstant: 10),
            genreLabel.topAnchor.constraint(equalTo: self.movieTitleLabel.bottomAnchor, constant: 0),
            genreLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            genreLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            genreLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func setupBindings() {
        viewModel.$moviePublisher
            .sink(receiveCompletion: { (completion) in
                
            }, receiveValue: { (movie) in
                
                self.movieTitleLabel.text = movie?.title
                
                if let _ = movie?.genre_ids {
                    self.genreLabel.text = movie?.getGenres()
                }
                
                if let urlString = movie?.poster_path {
                    DispatchQueue.global(qos: .utility).async {
                        self.fetchImage(urlString: urlString)
                    }
                }
            })
            .store(in: &cancellables)
    }
    
    private func fetchImage(urlString: String) {
        
        imageURL = urlString
        imageLoader?.loadImage(for: urlString)
            .sink(receiveCompletion: { (completion) in
                switch completion {
                    case .failure: self.thumbImageView.image = UIImage(named: "icon_img_unavailable")
                    case .finished: ()
                }
            }, receiveValue: { (image) in
                DispatchQueue.main.async {
                    self.thumbImageView.image = image
                    self.movieTitleLabel.sizeToFit()
                }
            })
            .store(in: &cancellables)
    }
    
    func addGradient() {
        
        gradientLayer.colors =  [UIColor.black.withAlphaComponent(0.4), UIColor.clear ].map{$0.cgColor}
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.3)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.3)
        thumbImageView.layer.insertSublayer(gradientLayer, at: 0)
    }
}
