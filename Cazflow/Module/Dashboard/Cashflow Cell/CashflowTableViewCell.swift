//
//  CashflowTableViewCell.swift
//  Cazflow
//
//  Created by Darindra R on 30/04/21.
//

import UIKit

class CashflowTableViewCell: UITableViewCell {
    @IBOutlet weak var cashflowNote: UILabel!
    @IBOutlet weak var cashflowNominal: UILabel!
    @IBOutlet weak var cashflowType: UILabel!


    static let cellIdentifier = "cashflowCell"
    public var cashflow: Cashflow? {
        didSet {
            if let cashflow = cashflow {
                cashflowNote.text = cashflow.note
                cashflowNominal.text = Utils.shared.formatRupiah(cashflow.nominal)
                cashflowType.text = cashflow.type?.uppercased()

                if cashflow.type?.uppercased() == "INCOME" {
                    cashflowType.textColor = UIColor.cazflowColor
                } else {
                    cashflowType.textColor = UIColor(hexString: "#8A8A8E")
                }
            }
        }
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    static func nib() -> UINib {
        return UINib(nibName: "CashflowTableViewCell", bundle: nil)
    }

}

fileprivate extension CashflowTableViewCell {
    func setup() {

    }
}
