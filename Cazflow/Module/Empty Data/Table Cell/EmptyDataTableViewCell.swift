//
//  EmptyDataTableViewCell.swift
//  Cazflow
//
//  Created by Darindra R on 03/05/21.
//

import UIKit

class EmptyDataTableViewCell: UITableViewCell {
    @IBOutlet weak var budgetEmptyLabel: UILabel!

    public var budgetEmpty: Bool? {
        didSet {
            budgetEmptyLabel.isHidden = true
        }
    }
    static let cellIdentifier = "emptyCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    static func nib() -> UINib {
        return UINib(nibName: "EmptyDataTableViewCell", bundle: nil)
    }
}

