//
//  MovieCell.swift
//  MoviDB
//
//  Created by Nitesh Singh on 29/06/22.
//

import Foundation
import UIKit

final class MovieCell: UICollectionViewCell {
    
    //MARK: Properties
    
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
        label.font = .cellTitle
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    lazy var genreLabel: VerticalAlignedLabel = {
        let label = VerticalAlignedLabel()
        label.font = .cellSubtitle
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    var imageLoader: ImageLoaderProtocol?
    
    //MARK: Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Dependency Injection
    
    func injectDependencies(imageLoader: ImageLoaderProtocol) {
        self.imageLoader = imageLoader
    }
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbImageView.image = nil
    }
    
    //MARK: Methods
    
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
    
    func configure(with movie: Movie) {
        self.populateViewsWithData(movie: movie)
    }
    
    private func populateViewsWithData(movie: Movie) {
        
        self.movieTitleLabel.text = movie.title
        self.movieTitleLabel.sizeToFit()
        if let _ = movie.genre_ids {
            self.genreLabel.text = movie.getGenres()
        }
        Task.detached {
            await self.downloadImage(for: movie)
        }
    }
    
    @MainActor private func downloadImage(for movie: Movie) async {
        guard let imageURL = movie.imagePath else { return }
        async let image = imageLoader?.image(from: imageURL)
        thumbImageView.image = try? await image
    }
}
