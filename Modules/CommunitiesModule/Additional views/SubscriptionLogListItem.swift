import SwiftUI

struct SubscriptionLogListItem: View {
    let log: UserLog
    var body: some View {
        VStack {
            if log.actionType == "favorite" {
                makeLogForFav()
            } else if log.actionType == "wallet" {
                makeLogForWallet()
            } else {
                makeLogForPortfolio()
            }
        }
        .padding()
        .frame(height: 120)
    }

    func makeLogForFav() -> AnyView {
        var removedOrAdded = Strings.removed
        if log.count == 1.0 {
            removedOrAdded = Strings.removed
        }
        return AnyView(
            VStack(alignment: .leading) {
                Text(log.userEmail)
                    .font(.title)
                Text(log.time)
                    .font(.caption)
                Text("\(Strings.favorites) \(removedOrAdded) \(log.itemId) ")
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.callout)
            }
        )
    }

    func makeLogForPortfolio() -> AnyView {
        var moreorless = Strings.removed
        var holdingChange = Strings.empty
        if log.count > log.count2 {
            moreorless = Strings.increased
            holdingChange = "\(log.count2) \(Strings.arrow) \(log.count) "
        } else if log.count < log.count2 && log.count > 0 { // swiftlint:disable:this empty_count
            moreorless = Strings.reduced
            holdingChange = "\(log.count2) \(Strings.arrow) \(log.count) "
        }
        return AnyView(
            VStack(alignment: .leading) {
                Text(log.userEmail)
                    .font(.title)
                Text(log.time)
                    .font(.caption)
                Text("\(Strings.portfolio) \(moreorless) \(log.itemId)  \(holdingChange)")
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.callout)
            }
        )
    }

    func makeLogForWallet() -> AnyView {
        AnyView(
            VStack(alignment: .leading) {
                Text(log.userEmail)
                    .font(.title)
                Text(log.time)
                    .font(.caption)
                Text("\(Strings.swapped) \(log.count.format2digits()) \(log.itemId) \(Strings.arrow) \(log.count2.format2digits()) \(log.itemId2)")
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.callout)
            }
        )
    }
// swiflint:disable:next line_length
    init(_ log: UserLog = UserLog(id: 1, actionType: "portfolio", time: "2022-10-25", userEmail: "koszti.dominik@gmail.com", count: 0.0, count2: 0.0, itemId: "bitcoin", itemId2: "")) {
        self.log = log
    }
}

struct SubscriptionLogListItem_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionLogListItem()
    }
}
