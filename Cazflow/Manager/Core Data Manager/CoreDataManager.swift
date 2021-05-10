//
//  CoreDataManager.swift
//  Cazflow
//
//  Created by Darindra R on 03/05/21.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager {
    // MARK: - Config CoreData
    static var shared = CoreDataManager()
    private init() { }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Cazflow")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    lazy var context: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()

    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    lazy var cashflowController: NSFetchedResultsController<Cashflow> = {
        let fetchRequest = NSFetchRequest<Cashflow>(entityName: "Cashflow")
        let sortDescriptor = NSSortDescriptor(key: #keyPath(Cashflow.date), ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = getPredicateForCashflow()

        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: #keyPath(Cashflow.getDateOnly),
            cacheName: nil)

        return fetchedResultsController
    }()

    lazy var budgetCashflowController: NSFetchedResultsController<Cashflow> = {
        let fetchRequest = NSFetchRequest<Cashflow>(entityName: "Cashflow")
        let sortDescriptor = NSSortDescriptor(key: #keyPath(Cashflow.date), ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]

        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: #keyPath(Cashflow.getDateOnly),
            cacheName: nil)

        return fetchedResultsController
    }()
}

// MARK: - Func for Business Processs
extension CoreDataManager {
    func createUser() {
        let coreDataUser = User(context: context)
        coreDataUser.balance = 0

        do {
            try context.save()
        } catch {
            fatalError()
        }
    }

    func fetchUser() -> User? {
        do {
            let users = try context.fetch(User.fetchRequest())
            return users[0] as? User
        } catch {
            fatalError()
        }
    }

    func fetchDashboardUser() -> GenerateUser? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Cashflow")
        let predicate = self.getPredicateForCashflow()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        let sortDescriptors = [sortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate

        do {
            let coreDataUser = try context.fetch(User.fetchRequest())
            let user = coreDataUser[0] as! User
            let cashflows = try context.fetch(fetchRequest)

            var income: Int64 = 0
            var expense: Int64 = 0

            for cashflow in cashflows as! [Cashflow] {
                if cashflow.type == "income" {
                    income += cashflow.nominal
                } else {
                    expense += cashflow.nominal
                }
            }

            return GenerateUser(balance: user.balance, income: income, expense: expense)
        } catch {
            fatalError()
        }
    }

    func fetchBudget() -> [Budget]? {
        do {
            return try context.fetch(Budget.fetchRequest())
        } catch {
            fatalError()
        }
    }

    func fetchBudgetCashflow(_ budget: Budget) {
        budgetCashflowController.fetchRequest.predicate = getPredicateForBudgetExpense(budget: budget)
        do {
            try budgetCashflowController.performFetch()
        } catch {
            fatalError()
        }
    }

    func fetchCashflow() {
        do {
            try cashflowController.performFetch()
        } catch {
            fatalError()
        }
    }

    func createBudget(_ user: User, _ budget: GenerateBudget) {
        let coreDataBudget = Budget(context: context)

        coreDataBudget.name = budget.name
        coreDataBudget.budgetDescription = budget.budgetDescription
        coreDataBudget.limit = budget.limit
        coreDataBudget.budget = budget.budget
        coreDataBudget.balance = budget.balance
        coreDataBudget.user = user

        do {
            try context.save()
        } catch {
            fatalError()
        }
    }

    func addIncome (_ user: User, cashflow: GenerateCashflow) {
        let coreDataCashflow = Cashflow(context: context)

        coreDataCashflow.type = cashflow.type
        coreDataCashflow.nominal = cashflow.nominal
        coreDataCashflow.source = cashflow.source
        coreDataCashflow.date = cashflow.date
        coreDataCashflow.note = cashflow.note
        coreDataCashflow.image = cashflow.image
        coreDataCashflow.user = user

        let newBalance = user.balance + cashflow.nominal
        user.balance = newBalance

        do {
            try context.save()
        } catch {
            fatalError()
        }
    }

    func addExpense (_ user: User, _ budget: Budget, _ cashflow: GenerateCashflow) {
        let coreDataCashflow = Cashflow(context: context)

        coreDataCashflow.type = cashflow.type
        coreDataCashflow.nominal = cashflow.nominal
        coreDataCashflow.date = cashflow.date
        coreDataCashflow.note = cashflow.note
        coreDataCashflow.image = cashflow.image
        coreDataCashflow.budget = budget
        coreDataCashflow.user = user

        let newBalance = user.balance - cashflow.nominal
        user.balance = newBalance

        let budgetExpense = budget.balance + cashflow.nominal
        budget.balance = budgetExpense

        do {
            try context.save()
        } catch {
            fatalError()
        }
    }
}

fileprivate extension CoreDataManager {
    func getPredicateForCashflow() -> NSCompoundPredicate {
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local

        let startOfMonth = Date().startOfMonth
        let endOfMonth = Date().endOfMonth


        let fromPredicate = NSPredicate(format: "date >= %@", startOfMonth as NSDate)
        let toPredicate = NSPredicate(format: "date <= %@", endOfMonth as NSDate)


        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
        return predicate
    }

    func getPredicateForBudgetExpense(budget: Budget) -> NSCompoundPredicate {
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local

        let startOfMonth = Date().startOfMonth
        let endOfMonth = Date().endOfMonth


        let fromPredicate = NSPredicate(format: "date >= %@", startOfMonth as NSDate)
        let toPredicate = NSPredicate(format: "date <= %@", endOfMonth as NSDate)
        let predicateBudget = NSPredicate(format: "budget == %@", budget)

        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate, predicateBudget])
        return predicate
    }
}
