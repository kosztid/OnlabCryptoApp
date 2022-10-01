class ListOfStocksInteractor {
    let model: DataModel

    init(model: DataModel) {
        self.model = model
    }

    func setIsnotificationViewed() {
        model.isNotificationViewed = true
    }

    func changeView() {
        model.currencyType = .crypto
    }
}
