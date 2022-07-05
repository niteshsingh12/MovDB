//
//  CastCell.swift
//  MoviDB
//
//  Created by Nitesh Singh on 01/07/22.
//

import Foundation
import UIKit

final class CastCell: UICollectionViewCell {
    
    //MARK: Properties
    
    static let cell_cell_reuse_identifier = "cast-cell-reuse-identifier"
    
    lazy var thumbImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8.0
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var castNameLabel: VerticalAlignedLabel = {
        let label = VerticalAlignedLabel()
        label.font = .cellTitle
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    lazy var characterNameLabel: VerticalAlignedLabel = {
        let label = VerticalAlignedLabel()
        label.font = .cellSubtitle
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    var imageLoader: ImageLoaderProtocol?
    
    //MARK: Dependency Injection
    
    func injectDependencies(imageLoader: ImageLoaderProtocol) {
        self.imageLoader = imageLoader
    }
    
    //MARK: Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbImageView.image = nil
    }
    
    //MARK: Methods
    
    private func setup() {
        let subviews = [thumbImageView, castNameLabel, characterNameLabel]
        
        subviews.forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            thumbImageView.topAnchor.constraint(equalTo: self.topAnchor),
            thumbImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            thumbImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            castNameLabel.heightAnchor.constraint(equalToConstant: 30),
            castNameLabel.topAnchor.constraint(equalTo: self.thumbImageView.bottomAnchor, constant: 0),
            castNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            castNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            characterNameLabel.heightAnchor.constraint(equalToConstant: 10),
            characterNameLabel.topAnchor.constraint(equalTo: self.castNameLabel.bottomAnchor, constant: 0),
            characterNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            characterNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            characterNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func configure(with cast: Cast) {
        self.populateViewsWithData(cast: cast)
    }
    
    private func populateViewsWithData(cast: Cast) {
        
        self.castNameLabel.text = cast.name
        self.characterNameLabel.text = cast.character
        Task.detached {
            await self.downloadImage(for: cast)
        }
    }
    
    @MainActor private func downloadImage(for cast: Cast) async {
        
        thumbImageView.image = .defaultCast
        guard let imageURL = cast.imagePath else { return }
        async let image = imageLoader?.image(from: imageURL)
        
        do {
            thumbImageView.image = try await image
        } catch {
            thumbImageView.image = .defaultCast
        }
    }
}
