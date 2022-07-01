//
//  MovieCell.swift
//  MoviDB
//
//  Created by Nitesh Singh on 29/06/22.
//

import Foundation
import UIKit
import Combine

final class LargeMovieCell: UICollectionViewCell {
    
    static let large_movie_cell_reuse_identifier = "large-movie-cell-reuse-identifier"
    
    lazy var thumbImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8.0
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var movieTitleLabel: VerticalAlignedLabel = {
        let label = VerticalAlignedLabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.contentMode = .bottom
        label.numberOfLines = 0
        return label
    }()
    
    lazy var releaseDateLabel: VerticalAlignedLabel = {
        let label = VerticalAlignedLabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.contentMode = .bottom
        label.numberOfLines = 0
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
        addGradient()
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
        let subviews = [movieTitleLabel, releaseDateLabel]
        
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
            
            releaseDateLabel.heightAnchor.constraint(equalToConstant: 30),
            releaseDateLabel.bottomAnchor.constraint(equalTo: self.movieTitleLabel.topAnchor, constant: -15),
            releaseDateLabel.leadingAnchor.constraint(equalTo: self.thumbImageView.leadingAnchor, constant: 15),
            releaseDateLabel.trailingAnchor.constraint(equalTo: self.thumbImageView.trailingAnchor, constant: -20),
        ])
    }
    
    private func setupBindings() {
        viewModel.$moviePublisher
            .sink(receiveCompletion: { (completion) in
                
            }, receiveValue: { (movie) in
                
                //self.releaseDateLabel.text = movie?.release_date
                self.movieTitleLabel.text = movie?.title
                if let urlString = movie?.backdrop_path {
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
        
        //gradientLayer.frame = CGRect(x: 0, y: self.thumbImageView.frame.height - 2, width: self.thumbImageView.frame.width, height: 2)
        gradientLayer.colors =  [UIColor.black.withAlphaComponent(0.4), UIColor.clear ].map{$0.cgColor}
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.3)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.3)
        thumbImageView.layer.insertSublayer(gradientLayer, at: 0)
    }
}

class VerticalAlignedLabel: UILabel {
    
    override func drawText(in rect: CGRect) {
        var newRect = rect
        switch contentMode {
        case .top:
            newRect.size.height = sizeThatFits(rect.size).height
        case .bottom:
            let height = sizeThatFits(rect.size).height
            newRect.origin.y += rect.size.height - height
            newRect.size.height = height
        default:
            ()
        }
        
        super.drawText(in: newRect)
    }
}
