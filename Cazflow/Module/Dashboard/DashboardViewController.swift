//
//  DashboardViewController.swift
//  Cazflow
//
//  Created by Darindra R on 29/04/21.
//

import UIKit
import CoreData

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
    private var dashboardUser = GenerateUser(balance: 0, income: 0, expense: 0)
    private var user: User?

    private lazy var cashflowController = CoreDataManager.shared.cashflowController


    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // MARK: Demo Purpose Only
//        CoreDataManager.shared.createUser()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUser()
        fetchDashboardUser()
        fetchBudget()
        fetchCashflow()
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
        addCashflowVC.user = user
        addCashflowVC.reloadCashflow = {
            self.fetchDashboardUser()
        }
        self.present(addCashflowVC, animated: true, completion: nil)
    }
}

fileprivate extension DashboardViewController {
    func setup() {
        topView.gradient(colors: UIColor.cazflowGradient)

        cashflowController.delegate = self

        balanceCard.layer.cornerRadius = 10
        balanceCard.dropShadow()

        proTips.text = tips.Title
        proTipsCard.layer.cornerRadius = 10
        proTipsCard.dropShadow()

        tableView.register(CashflowTableViewCell.nib(), forCellReuseIdentifier: CashflowTableViewCell.cellIdentifier)
        tableView.register(EmptyDataTableViewCell.nib(), forCellReuseIdentifier: EmptyDataTableViewCell.cellIdentifier)
        tableView.alwaysBounceVertical = false
        tableView.tableFooterView = UIView()
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
        CoreDataManager.shared.fetchCashflow()
    }

    func fetchDashboardUser() {
        if let dashboardUser = CoreDataManager.shared.fetchDashboardUser() {
            currentBalance.text = Utils.shared.formatRupiah(dashboardUser.balance)
            incomeBalance.text = Utils.shared.formatRupiah(dashboardUser.income)
            expenseBalance.text = Utils.shared.formatRupiah(dashboardUser.expense)
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
        let sectionCount = cashflowController.sections?.count ?? 0
        if sectionCount > 0 {
            let v = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
            let divider = UIView(frame: CGRect(x: 5, y: v.bounds.size.height - 1, width: tableView.frame.width - 10, height: 1))
            let label = UILabel(frame: CGRect(x: 12.0, y: 4.0, width: v.bounds.size.width - 16.0, height: v.bounds.size.height - 8.0))
            let sectionInfo = cashflowController.sections?[section]

            v.backgroundColor = .white
            divider.backgroundColor = .tertiarySystemFill
            label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            label.text = sectionInfo?.name
            label.font = UIFont.boldSystemFont(ofSize: 13)
            v.addSubview(label)
            v.addSubview(divider)
            return v
        }

        return UIView()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        if cashflowController.sections?.count == 0 { return 1 }
        return cashflowController.sections?.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cashflowController.sections?.count == 0 { return 1 }

        guard let sectionInfo = cashflowController.sections?[section] else { return 1 }
        return sectionInfo.numberOfObjects
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if cashflowController.fetchedObjects?.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: EmptyDataTableViewCell.cellIdentifier, for: indexPath)
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CashflowTableViewCell.cellIdentifier, for: indexPath) as! CashflowTableViewCell
            cell.cashflow = cashflowController.object(at: indexPath)
            return cell
        }
    }
}

extension DashboardViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller:
        NSFetchedResultsController<NSFetchRequestResult>,
    didChange anObject: Any,
    at indexPath: IndexPath?,
    for type: NSFetchedResultsChangeType,
    newIndexPath: IndexPath?) {
        if cashflowController.fetchedObjects?.count != 1 {
            switch type {
            case .insert:
                tableView.insertRows(at: [newIndexPath!], with: .automatic)
            case .delete:
                tableView.deleteRows(at: [indexPath!], with: .automatic)
            case .update:
                let cell = tableView.cellForRow(at: indexPath!) as! CashflowTableViewCell
                cell.cashflow = cashflowController.object(at: indexPath!)
            case .move:
                tableView.deleteRows(at: [indexPath!], with: .automatic)
                tableView.insertRows(at: [newIndexPath!], with: .automatic)
            @unknown default:
                print("Unexpected NSFetchedResultsChangeType")
            }
        } else {
            tableView.reloadData()
        }
    }

    func controllerDidChangeContent(_ controller:
        NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    func controller(_ controller:
        NSFetchedResultsController<NSFetchRequestResult>,
    didChange sectionInfo: NSFetchedResultsSectionInfo,
    atSectionIndex sectionIndex: Int,
    for type: NSFetchedResultsChangeType) {
        if sectionIndex > 0 {
            let indexSet = IndexSet(integer: sectionIndex)

            switch type {
            case .insert:
                tableView.insertSections(indexSet, with: .automatic)
            case .delete:
                tableView.deleteSections(indexSet, with: .automatic)
            default: break
            }
        }
    }
}
