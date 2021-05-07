//
//  EmptyDataCollectionViewCell.swift
//  Cazflow
//
//  Created by Darindra R on 03/05/21.
//

import UIKit

class EmptyDataCollectionViewCell: UICollectionViewCell {

    static let cellIdentifier = "emptyCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    static func nib() -> UINib {
        return UINib(nibName: "EmptyDataCollectionViewCell", bundle: nil)
    }
}
