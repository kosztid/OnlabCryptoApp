import Foundation

class ListOfCoinsInteractor {
    let model: DataModel
    
    init(model: DataModel) {
        self.model = model
    }

    func setIsnotificationViewed() {
        model.isNotificationViewed = true
    }

    func changeView() {
        model.currencyType = .stocks
    }
}
