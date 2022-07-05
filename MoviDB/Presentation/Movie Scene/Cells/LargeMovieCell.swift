//
//  MovieCell.swift
//  MoviDB
//
//  Created by Nitesh Singh on 29/06/22.
//

import Foundation
import UIKit

final class LargeMovieCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let large_movie_cell_reuse_identifier = "large-movie-cell-reuse-identifier"
    
    lazy var thumbImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8.0
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var movieTitleLabel: VerticalAlignedLabel = {
        let label = VerticalAlignedLabel()
        label.textColor = .white
        label.font = .largeCellTitle
        label.contentMode = .bottom
        label.numberOfLines = 0
        return label
    }()
    
    var gradientLayer = CAGradientLayer()
    var imageLoader: ImageLoaderProtocol?
    
    // MARK: - Dependency Injection
    
    func injectDependencies(imageLoader: ImageLoaderProtocol) {
        self.imageLoader = imageLoader
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
        addGradient()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = thumbImageView.frame
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbImageView.image = nil
    }
    
    // MARK: - Methods
    
    private func setup() {
        let subviews = [movieTitleLabel]
        
        thumbImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(thumbImageView)
        
        subviews.forEach {
            thumbImageView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            thumbImageView.topAnchor.constraint(equalTo: self.topAnchor),
            thumbImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            thumbImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            thumbImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            movieTitleLabel.heightAnchor.constraint(equalToConstant: 60),
            movieTitleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
            movieTitleLabel.leadingAnchor.constraint(equalTo: self.thumbImageView.leadingAnchor, constant: 15),
            movieTitleLabel.trailingAnchor.constraint(equalTo: self.thumbImageView.trailingAnchor, constant: -20),
        ])
    }
    
    func configure(with movie: Movie) {
        self.populateViewsWithData(movie: movie)
    }
    
    private func populateViewsWithData(movie: Movie) {
        
        self.movieTitleLabel.text = movie.title
        self.movieTitleLabel.sizeToFit()
        Task.detached {
            await self.downloadImage(for: movie)
        }
    }
    
    @MainActor private func downloadImage(for movie: Movie) async {
        guard let imageURL = movie.backdrop_imagePath else { return }
        async let image = imageLoader?.image(from: imageURL)
        thumbImageView.image = try? await image
    }
    
    func addGradient() {
        gradientLayer.colors =  [.clear, UIColor.black.withAlphaComponent(0.5)].map{$0.cgColor}
        gradientLayer.locations = [0.0, 0.8, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        thumbImageView.layer.insertSublayer(gradientLayer, at: 0)
    }
}
