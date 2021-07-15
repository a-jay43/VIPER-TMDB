//
//  MovieCell.swift
//  MovieSearch
//
//  Created by Mac on 7/14/21.
//

import UIKit

class MovieCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var layerView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.layer.cornerRadius = 8
        self.contentView.layer.masksToBounds = true
        self.contentView.backgroundColor = UIColor.lightGray
        imgView.image = nil
        layerView.backgroundColor = UIColor.purple.withAlphaComponent(0.12)
        layerView.bringSubviewToFront(imgView)
    }
    
    override func prepareForReuse() {
        titleLabel.text = nil
        imgView.image = nil
    }
    
    public func configure(movie: Movie) {
        titleLabel.text = movie.title
        overView.text = movie.overview
    }
}

