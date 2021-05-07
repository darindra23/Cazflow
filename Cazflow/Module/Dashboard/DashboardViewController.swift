//
//  DashboardViewController.swift
//  Cazflow
//
//  Created by Darindra R on 29/04/21.
//

import UIKit

class DashboardViewController: UIViewController {
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var userGreetings: UILabel!
    @IBOutlet weak var currentBalance: UILabel!
    @IBOutlet weak var incomeBalance: UILabel!
    @IBOutlet weak var expenseBalance: UILabel!
    @IBOutlet weak var balanceCard: UIView!
    @IBOutlet weak var addCashflowButton: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var proTipsCard: UIView!
    @IBOutlet weak var proTips: UILabel!


    private var tips: ProTips = ProTipsCollection.shared.getProTips()
    private var budgets = [Budget]()
    private var cashflows = [String: [Cashflow]]()
    private var dashboardUser = GenerateUser(balance: 0, income: 0, expense: 0)
    private var user = [User]()


    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
//        CoreDataManager.shared.createUser()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchBudget()
    }

    @IBAction func openProTips(_ sender: UITapGestureRecognizer) {
        let proTipsVC = ProTipsViewController()
        proTipsVC.proTips = tips
        self.present(proTipsVC, animated: true, completion: nil)
    }

    @IBAction func addCashflow(_ sender: UIButton) {
        let addCashflowVC = AddCashflowViewController(nibName: "AddCashflowViewController", bundle: nil)
        addCashflowVC.tag = sender.tag
        addCashflowVC.budgets = self.budgets
        addCashflowVC.user = self.user[0]
        addCashflowVC.reloadCashflow = {
            self.fetchCashflow()
            self.fetchDashboardUser()
            self.tableView.reloadData()

//            if self.cashflows.isEmpty {
//                self.tableView.reloadData()
//            } else {
//                let indexPath = IndexPath(row: 0, section: 0)
//                self.tableView.insertRows(at: [indexPath], with: .automatic)
//            }

        }
        self.present(addCashflowVC, animated: true, completion: nil)
    }
}

fileprivate extension DashboardViewController {
    func setup() {
        fetchBudget()
        fetchCashflow()
        fetchDashboardUser()
        fetchUser()
        topView.gradient(colors: UIColor.cazflowGradient)


        balanceCard.layer.cornerRadius = 10
        balanceCard.dropShadow()

        proTips.text = tips.Title
        proTipsCard.layer.cornerRadius = 10
        proTipsCard.dropShadow()

        tableView.register(CashflowTableViewCell.nib(), forCellReuseIdentifier: CashflowTableViewCell.cellIdentifier)
        tableView.register(EmptyDataTableViewCell.nib(), forCellReuseIdentifier: EmptyDataTableViewCell.cellIdentifier)
        tableView.alwaysBounceVertical = false
        tableView.tableFooterView = UIView()
        if budgets.count < 1 {
            tableView.separatorStyle = .none
        }
    }

    func fetchBudget() {
        if let budgets = CoreDataManager.shared.fetchBudget() {
            if budgets.count < 1 {
                addCashflowButton.isHidden = true
            } else {
                addCashflowButton.isHidden = false
            }
            self.budgets = budgets
        }
    }

    func fetchCashflow() {
        if let cashflow = CoreDataManager.shared.fetchCashflow() {
            self.cashflows = cashflow
        }
    }

    func fetchDashboardUser() {
        if let dashboardUser = CoreDataManager.shared.fetchDashboardUser() {
            currentBalance.text = Rupiah.formatRupiah(dashboardUser.balance)
            incomeBalance.text = Rupiah.formatRupiah(dashboardUser.income)
            expenseBalance.text = Rupiah.formatRupiah(dashboardUser.expense)
            self.dashboardUser = dashboardUser
        }
    }

    func fetchUser() {
        if let user = CoreDataManager.shared.fetchUser() {
            self.user = user
        }
    }
}

extension DashboardViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if !cashflows.isEmpty {
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
        } else {
            return UIView()
        }
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
            let cell = tableView.dequeueReusableCell(withIdentifier: EmptyDataTableViewCell.cellIdentifier, for: indexPath)
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
