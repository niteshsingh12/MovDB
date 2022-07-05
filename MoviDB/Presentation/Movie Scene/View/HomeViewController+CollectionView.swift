//
//  HomeViewController+CollectionView.swift
//  MoviDB
//
//  Created by Nitesh Singh on 05/07/22.
//

import UIKit

//MARK: HomeViewController + Collection

extension HomeViewController {
    
    /*
     Register view cells (for movies) and header view.
    */
    func registerViews() {
        collectionView.register(LargeMovieCell.self, forCellWithReuseIdentifier: LargeMovieCell.large_movie_cell_reuse_identifier)
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.movie_cell_reuse_identifier)
        collectionView.register(HeaderView.self,
                                forSupplementaryViewOfKind: HeaderView.sectionHeaderElementKind,
                                withReuseIdentifier: HeaderView.reuseIdentifier)
        collectionView.delegate = self
    }
    
    /*
     Setup collection diffable datasource and supplementary header view
    */
    func setupDatasource() {
        
        datasource = DataSource(collectionView: collectionView, cellProvider: {
            (collectionView, indexPath, movie) in
            
            guard let section = MovieType(rawValue: indexPath.section) else { fatalError("Unknown section") }
            
            switch section {
                case .nowPlaying:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LargeMovieCell.large_movie_cell_reuse_identifier, for: indexPath) as! LargeMovieCell
                    cell.injectDependencies(imageLoader: self.imageLoader)
                    cell.configure(with: movie)
                    return cell
                    
                default:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.movie_cell_reuse_identifier, for: indexPath) as! MovieCell
                    cell.injectDependencies(imageLoader: self.imageLoader)
                    cell.configure(with: movie)
                    return cell
            }
        })
        
        datasource.supplementaryViewProvider = { (collectionView, kind, indexPath) -> UICollectionReusableView? in
            
            guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.reuseIdentifier, for: indexPath) as? HeaderView else {
                fatalError()
            }
            supplementaryView.configure(padding: 10, font: .headerBig)
            let currentSnapshot = self.datasource.snapshot()
            let section = currentSnapshot.sectionIdentifiers[indexPath.section]
            supplementaryView.headerLabel.text = section.getTitle()
            return supplementaryView
        }
    }
    
    /*
     Generate compositional layout
    */
    func generateCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (section, env) -> NSCollectionLayoutSection? in
            
            guard let section = MovieType(rawValue: section) else { fatalError("Unknown section") }
            switch section {
                case .nowPlaying: return CollectionLayoutGenerator.generateLayoutForLargeCell()
                default: return CollectionLayoutGenerator.generateLayoutForNormalMovieCell()
            }
        }
    }
}

//MARK: HomeViewController + Collection Delegate

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movie = datasource.itemIdentifier(for: indexPath) else { return }
        coordinator?.moveToMovieDetailWith(movie: movie)
    }
}
