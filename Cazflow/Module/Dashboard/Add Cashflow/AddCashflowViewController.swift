//
//  AddCashflowViewController.swift
//  Cazflow
//
//  Created by Darindra R on 03/05/21.
//

import UIKit

class AddCashflowViewController: UIViewController {
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var cashflowType: UILabel!
    @IBOutlet weak var cashflowIcon: UIImageView!
    @IBOutlet weak var cashflowNominal: UITextField!
    @IBOutlet weak var cashflowSource: UITextField!
    @IBOutlet weak var cashflowBudget: UITextField!
    @IBOutlet weak var cashflowWhen: UIDatePicker!
    @IBOutlet weak var cashflowPicture: UIImageView!
    @IBOutlet weak var cashflowNote: UITextField!
    @IBOutlet weak var nominalDivider: UIView!
    @IBOutlet weak var sourceStack: UIStackView!
    @IBOutlet weak var sourceDivider: UIView!
    @IBOutlet weak var budgetStack: UIStackView!
    @IBOutlet weak var budgetDivider: UIView!
    @IBOutlet weak var whenStack: UIStackView!
    @IBOutlet weak var photoStack: UIStackView!
    @IBOutlet weak var photoTopDivider: UIView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var noteStack: UIStackView!
    @IBOutlet weak var containerView: UIView!
    private var pickerView = UIPickerView()

    public var tag: Int?
    public var reloadCashflow: (() -> ())?
    public var user: User?
    public var budgets: [Budget]?
    private var selectedBudget: Budget?


    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    @IBAction func attachPhoto(_ sender: Any) {
    }

    @IBAction func saveCashflow(_ sender: Any) {
        guard let user = user else { return }
        guard let nominalText = cashflowNominal.text else { return }
        let nominal = nominalText.removeFormatAmount()

        let when = cashflowWhen.date
        guard let note = cashflowNote.text else { return }

        let cashflow: GenerateCashflow

        if tag == 0 {
            guard let source = cashflowSource.text else { return }
            cashflow = GenerateCashflow(type: "income", note: note, nominal: nominal, image: "test", date: when, source: source)
            CoreDataManager.shared.addIncome(user, cashflow: cashflow)
        } else {
            guard let budget = selectedBudget else { return }
            cashflow = GenerateCashflow(type: "expense", note: note, nominal: nominal, image: "text", date: when)
            CoreDataManager.shared.addExpense(user, budget, cashflow)
        }

        reloadCashflow?()
        self.dismiss(animated: true, completion: nil)
    }
}

fileprivate extension AddCashflowViewController {
    func setup() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        topView.gradient(colors: UIColor.cazflowGradient)
        saveButton.layer.cornerRadius = 10
        saveButton.dropShadow()

        view.addGestureRecognizer(tap)
        cashflowNominal.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)

        if let tag = tag {
            switch tag {
            case 0:
                setupIncome()
            default:
                setupExpense()
            }
        }

        // MARK: Demo Purpose Only
        photoStack.isHidden = true
        photoTopDivider.isHidden = true
        cashflowPicture.isHidden = true
        NSLayoutConstraint.activate([
            containerView.bottomAnchor.constraint(equalTo: noteStack.bottomAnchor, constant: 15)
        ])
    }

    func setupIncome() {
        cashflowType.text = "Income"
        cashflowIcon.image = UIImage(named: "Income")
        budgetStack.isHidden = true
        budgetDivider.isHidden = true

        NSLayoutConstraint.activate([
            whenStack.topAnchor.constraint(equalTo: sourceDivider.bottomAnchor, constant: 10)
        ])
    }

    func setupExpense() {
        bindData()
        createPickerView()

        cashflowType.text = "Expense"
        cashflowIcon.image = UIImage(named: "Expense")
        cashflowNote.placeholder = "Lunch"
        sourceStack.isHidden = true
        sourceDivider.isHidden = true

        NSLayoutConstraint.activate([
            budgetStack.topAnchor.constraint(equalTo: nominalDivider.bottomAnchor, constant: 10)
        ])

        guard let budgets = self.budgets else { return }
        if budgets.count == 1 {
            cashflowBudget.text = budgets[0].name?.capitalized
            selectedBudget = budgets[0]
        }
    }

    func bindData() {
        guard let budgets = self.budgets else { return }
        self.budgets = budgets
    }

    func createPickerView() {
        let toolBar: UIToolbar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44))
        let spaceButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.tapDone))
        doneButton.tintColor = UIColor.cazflowColor
        toolBar.setItems([spaceButton, doneButton], animated: true)

        pickerView.delegate = self
        pickerView.dataSource = self
        cashflowBudget.delegate = self
        cashflowBudget.inputView = pickerView
        cashflowBudget.layer.cornerRadius = 5
        cashflowBudget.tintColor = .clear
        cashflowBudget.inputAccessoryView = toolBar
    }

    @objc func tapDone() {
        guard let budgets = self.budgets else { return }
        if selectedBudget == nil {
            cashflowBudget.text = budgets[0].name?.capitalized
            selectedBudget = budgets[0]
        }
        cashflowBudget.resignFirstResponder()
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

extension AddCashflowViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let budgets = self.budgets else { return 0 }
        return budgets.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let budgets = self.budgets else { return "" }
        return budgets[row].name?.capitalized
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let budgets = self.budgets else { return }
        cashflowBudget.text = budgets[row].name?.capitalized
        selectedBudget = budgets[row]
    }

}

extension AddCashflowViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard let budgets = self.budgets else { return true }
        return budgets.count > 1 ? true : false
    }
}
