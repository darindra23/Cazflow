//
//  BudgetDetailViewController.swift
//  Cazflow
//
//  Created by Darindra R on 01/05/21.
//

import UIKit

class BudgetDetailViewController: UIViewController {
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var budgetDetailTitle: UILabel!
    @IBOutlet weak var budgetDetailDescription: UILabel!

    public var user: User?
    private var cashflows = [String: [Cashflow]]()
    var budget: Budget?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bindData()
    }

    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func addExpense(_ sender: UIButton) {
        guard let user = self.user else { return }
        guard let budget = self.budget else { return }
        let addCashflowVC = AddCashflowViewController(nibName: "AddCashflowViewController", bundle: nil)
        addCashflowVC.tag = 1
        addCashflowVC.user = user
        addCashflowVC.budgets = [budget]
        addCashflowVC.reloadCashflow = {
            guard let budget = self.budget else { return }
            self.fetchCashflow(budget)

            if self.cashflows.isEmpty {
                self.tableView.reloadData()
            } else {
                let indexPath = IndexPath(row: 0, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .automatic)
            }
        }
        self.present(addCashflowVC, animated: true, completion: nil)
    }
}

fileprivate extension BudgetDetailViewController {
    func setup() {
        topView.gradient(colors: UIColor.cazflowGradient)

        tableView.register(EmptyDataTableViewCell.nib(), forCellReuseIdentifier: EmptyDataTableViewCell.cellIdentifier)
        tableView.register(CashflowTableViewCell.nib(), forCellReuseIdentifier: CashflowTableViewCell.cellIdentifier)
        tableView.tableFooterView = UIView()
    }

    func bindData() {
        guard let budget = budget else { return }
        fetchCashflow(budget)
        budgetDetailTitle.text = budget.name
        budgetDetailDescription.text = budget.budgetDescription

        if cashflows.count < 1 {
            tableView.separatorStyle = .none
        }
    }

    func fetchCashflow(_ budget: Budget) {
        guard let cashflowCoreData = CoreDataManager.shared.fetchBudgetCashflow(budget: budget) else { return }
        cashflows = cashflowCoreData
    }
}

extension BudgetDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if cashflows.count >= 1 {
            let v = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
            let divider = UIView(frame: CGRect(x: 5, y: v.bounds.size.height - 1, width: tableView.frame.width - 10, height: 1))

            v.backgroundColor = .white
            divider.backgroundColor = .tertiarySystemFill
            let label = UILabel(frame: CGRect(x: 12.0, y: 4.0, width: v.bounds.size.width - 16.0, height: v.bounds.size.height - 8.0))
            label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            label.text = Array(cashflows)[section].key
            label.font = UIFont.boldSystemFont(ofSize: 13)
            v.addSubview(label)
            v.addSubview(divider)
            return v
        }

        return UIView()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        if cashflows.count < 1 {
            return 1
        } else {
            return cashflows.count
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cashflows.count < 1 {
            return 1
        } else {
            return Array(cashflows)[section].value.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if cashflows.count < 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: EmptyDataTableViewCell.cellIdentifier, for: indexPath) as!EmptyDataTableViewCell
            cell.budgetEmpty = true
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CashflowTableViewCell.cellIdentifier, for: indexPath) as! CashflowTableViewCell
            let cashflowKey = Array(cashflows)[indexPath.section].key
            guard let cashflows = cashflows[cashflowKey] else { return cell }
            cell.cashflow = cashflows[indexPath.row]
            return cell
        }
    }
}
