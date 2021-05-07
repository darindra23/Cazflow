//
//  AddBudgetViewController.swift
//  Cazflow
//
//  Created by Darindra R on 03/05/21.
//

import UIKit

class AddBudgetViewController: UIViewController {
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var budgetCap: UITextField!
    @IBOutlet weak var budgetName: UITextField!
    @IBOutlet weak var budgetDescription: UITextField!
    @IBOutlet weak var budgetLimit: UITextField!
    @IBOutlet weak var saveButton: UIButton!

    public var reloadCollection: (() -> ())?
    public var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    @IBAction func save(_ sender: UIButton) {
        guard let user = user else { return }
        guard let name = budgetName.text else { return }
        guard let description = budgetDescription.text else { return }
        guard let capText = budgetCap.text else { return }
        guard let limitText = budgetLimit.text else { return }
        guard let limit = Int64(limitText) else { return }
        let cap = capText.removeFormatAmount()

        let budget = GenerateBudget(
            name: name,
            limit: limit,
            budgetDescription: description,
            budget: cap,
            balance: 0)

        CoreDataManager.shared.createBudget(user, budget)
        reloadCollection?()
        self.dismiss(animated: true)
    }
}

fileprivate extension AddBudgetViewController {
    func setup() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        topView.gradient(colors: UIColor.cazflowGradient)
        saveButton.layer.cornerRadius = 10

        view.addGestureRecognizer(tap)
        budgetCap.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
    }

    @objc func myTextFieldDidChange(_ textField: UITextField) {
        if let amountString = textField.text?.currencyInputFormatting() {
            textField.text = amountString
        }
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
