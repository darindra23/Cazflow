//
//  BudgetViewController.swift
//  Cazflow
//
//  Created by Darindra R on 30/04/21.
//

import UIKit

class BudgetViewController: UIViewController {
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addBudgetButton: UIButton!
    @IBOutlet weak var balance: UILabel!

    private var budgets = [Budget]()
    private var user = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchBudget()
    }

    @IBAction func addBudget(_ sender: Any) {
        let addBudgetVC = AddBudgetViewController(nibName: "AddBudgetViewController", bundle: nil)
        addBudgetVC.user = self.user[0]
        addBudgetVC.reloadCollection = {
            self.fetchBudget()
            let indexPath = IndexPath(row: self.budgets.count - 1, section: 0)
            self.collectionView.insertItems(at: [indexPath])
        }
        self.present(addBudgetVC, animated: true, completion: nil)
    }
}

fileprivate extension BudgetViewController {
    func setup() {
        self.fetchBudget()
        self.fetchUser()
        self.navigationController?.isNavigationBarHidden = true
        topView.gradient(colors: UIColor.cazflowGradient)

        addBudgetButton.layer.cornerRadius = 10
        addBudgetButton.dropShadow()

        balance.dropShadow()
        collectionView.register(BudgetCell.nib(), forCellWithReuseIdentifier: BudgetCell.cellIdentifier)
        collectionView.register(EmptyDataCollectionViewCell.nib(), forCellWithReuseIdentifier: EmptyDataCollectionViewCell.cellIdentifier)
    }

    func fetchBudget() {
        if let budgets = CoreDataManager.shared.fetchBudget() {
            self.budgets = budgets
        }
    }

    func fetchUser() {
        if let user = CoreDataManager.shared.fetchUser() {
            self.user = user
        }
    }
}


extension BudgetViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if budgets.count < 1 {
            return 1
        } else {
            return budgets.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if budgets.count < 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyDataCollectionViewCell.cellIdentifier, for: indexPath)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BudgetCell.cellIdentifier, for: indexPath) as! BudgetCell
            cell.budget = budgets[indexPath.row]
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if budgets.count > 0 {
            let budgetDetailVC = BudgetDetailViewController(nibName: "BudgetDetailViewController", bundle: nil)
            budgetDetailVC.budget = budgets[indexPath.row]
            budgetDetailVC.user = user[0]
            self.navigationController?.pushViewController(budgetDetailVC, animated: true)
        }
    }
}
