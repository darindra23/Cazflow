//
//  BudgetCell.swift
//  Cazflow
//
//  Created by Darindra R on 01/05/21.
//

import UIKit

class BudgetCell: UICollectionViewCell {
    @IBOutlet weak var budgetCard: UIView!
    @IBOutlet weak var budgetTitle: UILabel!
    @IBOutlet weak var budgetDescription: UILabel!
    @IBOutlet weak var budgetLimit: UILabel!
    @IBOutlet weak var budgetExpense: UILabel!
    @IBOutlet weak var budgetProgress: UIProgressView!

    static let cellIdentifier = "budgetCell"

    public var budget: Budget? {
        didSet {
            if let budget = budget {
                budgetTitle.text = budget.name?.capitalized
                budgetDescription.text = budget.budgetDescription?.capitalized
                budgetLimit.text = Rupiah.formatRupiah(budget.budget)
                budgetExpense.text = Rupiah.formatRupiah(budget.balance)
                budgetProgress.setProgress(Float(Float(budget.balance) / Float(budget.budget)), animated: true)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    static func nib() -> UINib {
        return UINib(nibName: "BudgetCell", bundle: nil)
    }

}

fileprivate extension BudgetCell {
    func setup() {
        budgetCard.layer.cornerRadius = 10
        budgetCard.dropShadow()
    }
}
