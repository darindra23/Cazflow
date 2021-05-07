//
//  ProTipsViewController.swift
//  Cazflow
//
//  Created by Darindra R on 01/05/21.
//

import UIKit

class ProTipsViewController: UIViewController {
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var titleProTips: UILabel!
    @IBOutlet weak var descriptionProTips: UILabel!
    @IBOutlet weak var whyItWorks: UILabel!
    @IBOutlet weak var whenItDoesnt: UILabel!

    var proTips: ProTips?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

fileprivate extension ProTipsViewController {
    func setup() {
        guard let proTips = self.proTips else { return }

        topView.gradient(colors: UIColor.cazflowGradient)

        titleProTips.text = proTips.Title
        descriptionProTips.text = proTips.Description
        whyItWorks.text = proTips.Why
        whenItDoesnt.text = proTips.When
    }
}
