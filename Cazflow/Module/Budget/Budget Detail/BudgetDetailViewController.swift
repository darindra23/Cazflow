//
//  BudgetDetailViewController.swift
//  Cazflow
//
//  Created by Darindra R on 01/05/21.
//

import UIKit
import CoreData

class BudgetDetailViewController: UIViewController {
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var budgetDetailTitle: UILabel!
    @IBOutlet weak var budgetDetailDescription: UILabel!

    var user: User?
    var budget: Budget?
    private lazy var budgetCashflowController = CoreDataManager.shared.budgetCashflowController

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

        CoreDataManager.shared.budgetCashflowController.delegate = self
        CoreDataManager.shared.fetchBudgetCashflow(budget)

        let sectionCount = budgetCashflowController.sections?.count ?? 0

        budgetDetailTitle.text = budget.name
        budgetDetailDescription.text = budget.budgetDescription

        if sectionCount < 1 {
            tableView.separatorStyle = .none
        }
    }
}

extension BudgetDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionCount = budgetCashflowController.sections?.count ?? 0
        if sectionCount > 0 {
            let v = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
            let divider = UIView(frame: CGRect(x: 5, y: v.bounds.size.height - 1, width: tableView.frame.width - 10, height: 1))
            let label = UILabel(frame: CGRect(x: 12.0, y: 4.0, width: v.bounds.size.width - 16.0, height: v.bounds.size.height - 8.0))
            let sectionInfo = budgetCashflowController.sections?[section]

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
        if budgetCashflowController.sections?.count == 0 { return 1 }
        return budgetCashflowController.sections?.count ?? 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if budgetCashflowController.sections?.count == 0 { return 1 }

        guard let sectionInfo = budgetCashflowController.sections?[section] else { return 1 }
        return sectionInfo.numberOfObjects
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if budgetCashflowController.fetchedObjects?.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: EmptyDataTableViewCell.cellIdentifier, for: indexPath)
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CashflowTableViewCell.cellIdentifier, for: indexPath) as! CashflowTableViewCell
            cell.cashflow = budgetCashflowController.object(at: indexPath)
            return cell
        }
    }
}

extension BudgetDetailViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller:
        NSFetchedResultsController<NSFetchRequestResult>,
    didChange anObject: Any,
    at indexPath: IndexPath?,
    for type: NSFetchedResultsChangeType,
    newIndexPath: IndexPath?) {
        if budgetCashflowController.fetchedObjects?.count != 1 {
            switch type {
            case .insert:
                tableView.insertRows(at: [newIndexPath!], with: .automatic)
            case .delete:
                tableView.deleteRows(at: [indexPath!], with: .automatic)
            case .update:
                let cell = tableView.cellForRow(at: indexPath!) as! CashflowTableViewCell
                cell.cashflow = budgetCashflowController.object(at: indexPath!)
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
