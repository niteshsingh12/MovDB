//
//  MovieDetailViewController.swift
//  MoviDB
//
//  Created by Nitesh Singh on 30/06/22.
//

import Foundation
import UIKit

final class MovieDetailViewController: UIViewController {
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var ratingsLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var detailsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    private typealias Datasource = UICollectionViewDiffableDataSource<MovieType,Movie>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<MovieType, Movie>
    private var datasource: Datasource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setup() {
    }
}
