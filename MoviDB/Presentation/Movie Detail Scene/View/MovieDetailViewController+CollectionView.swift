//
//  MovieDetailViewController+CollectionView.swift
//  MoviDB
//
//  Created by Nitesh Singh on 04/07/22.
//

import Foundation
import UIKit

//MARK: MovieDetailViewController + Collection

extension MovieDetailViewController: UICollectionViewDelegate {
    
    /*
     Register view cells (for similar movies & cast, and header view.
    */
    func registerViews() {
        collectionView.register(CastCell.self, forCellWithReuseIdentifier: CastCell.cell_cell_reuse_identifier)
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.movie_cell_reuse_identifier)
        collectionView.register(HeaderView.self,
                                forSupplementaryViewOfKind: HeaderView.sectionHeaderElementKind,
                                withReuseIdentifier: HeaderView.reuseIdentifier)
        collectionView.delegate = self
    }
    
    /*
     Generate compositional layout
    */
    func generateCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (section, env) -> NSCollectionLayoutSection? in
            return CollectionLayoutGenerator.generateLayoutForNormalMovieCell()
        }
    }
    
    /*
     Setup collection diffable datasource and supplementary header view
    */
    func setupDatasource() {
        
        datasource = Datasource(collectionView: collectionView, cellProvider: {
            (collectionView, indexPath, item) in
                        
            switch item {
                    
                case let movie as Movie:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.movie_cell_reuse_identifier, for: indexPath) as! MovieCell
                    cell.injectDependencies(imageLoader: self.imageLoader)
                    cell.configure(with: movie)
                    return cell
                    
                case let cast as Cast:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCell.cell_cell_reuse_identifier, for: indexPath) as! CastCell
                    cell.injectDependencies(imageLoader: self.imageLoader)
                    cell.configure(with: cast)
                    return cell
                    
                default: return UICollectionViewCell()
            }
        })
        
        datasource.supplementaryViewProvider = { (collectionView, kind, indexPath) -> UICollectionReusableView? in
            
            guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.reuseIdentifier, for: indexPath) as? HeaderView else {
                fatalError()
            }
            
            supplementaryView.configure(padding: 0, font: .detailHeader)
            let currentSnapshot = self.datasource.snapshot()
            let section = currentSnapshot.sectionIdentifiers[indexPath.section]
            supplementaryView.headerLabel.text = section.getTitle()
            return supplementaryView
        }
    }
}
