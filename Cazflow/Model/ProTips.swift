//
//  ProTips.swift
//  Cazflow
//
//  Created by Darindra R on 03/05/21.
//

import Foundation

struct ProTips {
    var Title: String
    var Description: String
    var Why: String
    var When: String
}

struct ProTipsCollection {
    static var shared = ProTipsCollection()
    private init() { }

    private var Collection = [
        ProTips(Title: "The 50/30/20 Budgeting rule",
                Description: """
                This is a popular rule for breaking down your budget. The 50-30-20 rule is 50% of your income for necessities, like housing and bills; 30% for wants, like dining or entertainment; and 20% for financial goals, like paying off debt or saving for retirement.
                
                There are looser variations to this rule, like the 80-20 rule, in which you use 20% of your income for financial goals and spend 80 percent on everything else.
                """,
                Why: "If you’re not sure where to start with a budget, breaking it up into these basic categories can be really helpful. Those percentages help create a balance between obligations, goals, and splurges.",
                When: "If you’re not earning much, you might not have the luxury of only spending half your income on necessities."),
        ProTips(Title: "Buying a vehicle rule",
                Description: """
                When buying a car, you should put down at least 20%, keep your car loan limited to no more than four years (to avoid interest), and spend no more than 10% of your gross income on transportation costs.
                """,
                Why: "It keeps you from buying more vehicles than you can afford. Cars are expensive to maintain and this formula takes your ongoing vehicle budget into consideration by calculating total transportation costs. These costs include your car payment, parking, gas, and insurance (which varies by vehicle type).",
                When: "Depending on your situation, these numbers might not be realistic for you. For example, you might spend more than 10% of your gross income on transportation because you have a long, gas-guzzling commute to a low-paying job. Since you need your car to work, you might look elsewhere in your budget to cut costs."),
        ProTips(Title: "The 20% Homeownership",
                Description: """
                You should put at least 20% down when buying a home.
                Don’t buy a house that costs more than three years’ worth of your gross annual income. Some variations say no more than two years; others say two and a half.
                
                These general rules give you an approximate amount to start with when thinking about homeownership. But there’s a long list of expenses, including closing costs, to consider, too. And it all varies. Check out our list of homeownership expenses that you might overlook before you start looking.
                """,
                Why: "It ensures that you don’t buy more homes than you can afford, lowers your monthly mortgage cost, and can increase your chances of being approved for the loan. You also won’t have to pay private mortgage insurance.",
                When: "While this is commonly accepted as practical advice, opinions can vary. Some consider 20% unrealistic as it’s an overwhelming amount to save."),
        ProTips(Title: "The 10% Retirement rule",
                Description: """
                “Save 10% of your income for retirement” is a very common rule of thumb.
                """,
                Why: "It gives people a simple number to work with. If you’re young, just opened a 401(k), and you’re not sure how much of your earnings to set aside, 10% is a good start.",
                When: "While 10% is a simple rule to follow, the percentage doesn’t consider how much you’ll actually need in retirement. It also doesn’t consider how much you’ve currently saved. If you’re playing catch-up, you’ll probably need to save considerably more than 10% of your income. Similarly, if you want to retire early, or more lavishly, you’ll likely need to save more than 10%."),
        ProTips(Title: "The income rule",
                Description: """
                You should save 20x your gross annual income.
                These retirement rules offer ballpark numbers, but if you want a more accurate approach that considers all the variables, develop a detailed vision of your retirement. Then, calculate how much that lifestyle will cost.
                """,
                Why: "It helps you focus on what you’ll need in the future.",
                When: "It’s more of a common benchmark than a one-size-fits-all formula. Your retirement expenses might differ from how much income you earn now, and depending on the lifestyle you plan to live, you may need a lot more (or less) than 20x your income."),
        ProTips(Title: "Student Loans rule",
                Description: """
                You shouldn’t take out more in student loans than you expect to make your first year on the job.
                This is a sticky and complicated topic. As we’re in the middle of a student debt crisis, not to mention a recession, it’s easy to dismiss this rule. But it’s important to have a realistic idea of what your income and repayment are going to look like after college, especially as it relates to your major. You’ll also want to compare the cost of an education at different universities to get a better idea of what you can afford.
                """,
                Why: "It ensures you’re taking out an affordable amount that you’ll be able to repay.",
                When: "Skyrocketing tuition rates have made following this rule a challenge, as have unemployment rates right after graduation."),
        ProTips(Title: "The emergency fund rule",
                Description: """
                You should have six months’ worth of savings on hand in case of an emergency.
                It’s can be really hard to hear “you should save an emergency fund” when you’re broke, so with that in mind here’s a Lifehacker post on alternative ways to get some emergency cash.
                """,
                Why: "Obviously, this is a big help in case an emergency arises in your life. It keeps you from having to make desperate decisions that can set you back.",
                When: "There are many different opinions on how much you should save, but as we know from the pandemic, even this may not be enough."),
    ]

    func getProTips() -> ProTips {
        let randomIndex = Int.random(in: 0...Collection.count - 1)
        return Collection[randomIndex]
    }

}
