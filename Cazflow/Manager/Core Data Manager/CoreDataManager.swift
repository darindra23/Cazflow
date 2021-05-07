//
//  CoreDataManager.swift
//  Cazflow
//
//  Created by Darindra R on 03/05/21.
//

import Foundation
import CoreData

struct CoreDataManager {
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

    func saveContext () {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

fileprivate extension CoreDataManager {

}
// MARK: - Func for Business Processs
extension CoreDataManager {
    func createUser() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let coreDataUser = User(context: context)

        coreDataUser.balance = 0

        do {
            try context.save()
        } catch {
            fatalError()
        }
    }

    func fetchUser() -> [User]? {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        do {
            return try context.fetch(User.fetchRequest())
        } catch {
            fatalError()
        }
    }

    func fetchDashboardUser() -> GenerateUser? {
        let context = CoreDataManager.shared.persistentContainer.viewContext
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
        let context = CoreDataManager.shared.persistentContainer.viewContext
        do {
            return try context.fetch(Budget.fetchRequest())
        } catch {
            fatalError()
        }
    }

    func createBudget(_ user: User, _ budget: GenerateBudget) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
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
        let context = CoreDataManager.shared.persistentContainer.viewContext
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
        let context = CoreDataManager.shared.persistentContainer.viewContext
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

    func fetchBudgetCashflow(budget: Budget) -> [String: [Cashflow]]? {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Cashflow")
        let predicate = self.getPredicateForBudgetExpense(budget: budget)
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        let sortDescriptors = [sortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate

        var groupedCashflow = [String: [Cashflow]]()

        do {
            if let cashflows = try context.fetch(fetchRequest) as? [Cashflow] {
                for cashflow in cashflows {
                    if let date = cashflow.date?.getDateOnly {
                        if groupedCashflow[date] != nil {
                            var cashflowArray = groupedCashflow[date]
                            cashflowArray?.append(cashflow)
                            groupedCashflow[date] = cashflowArray
                        } else {
                            groupedCashflow[date] = [cashflow]
                        }
                    }
                }
            }
        } catch {
            fatalError()
        }
        return groupedCashflow
    }

    func fetchCashflow() -> [String: [Cashflow]]? {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Cashflow")
        let predicate = self.getPredicateForCashflow()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        let sortDescriptors = [sortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate
        var groupedCashflow = [String: [Cashflow]]()

        do {
            if let cashflows = try context.fetch(fetchRequest) as? [Cashflow] {
                for cashflow in cashflows {
                    if let date = cashflow.date?.getDateOnly {
                        if groupedCashflow[date] != nil {
                            var cashflowArray = groupedCashflow[date]
                            cashflowArray?.append(cashflow)
                            groupedCashflow[date] = cashflowArray
                        } else {
                            groupedCashflow[date] = [cashflow]
                        }
                    }
                }
            }
        } catch {
            fatalError()
        }
        return sortWithKeys(groupedCashflow) as? [String: [Cashflow]]
    }
}

fileprivate extension CoreDataManager {
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

    func sortWithKeys(_ dict: [String: Any]) -> [String: Any] {
        let sortedKey = Array(dict.keys).sorted(by: >)
        var newDict: [String: Any] = [:]
        for key in sortedKey {
            print(key)
            newDict[key] = dict[key]
        }

        print(newDict)
        return newDict
    }
}
