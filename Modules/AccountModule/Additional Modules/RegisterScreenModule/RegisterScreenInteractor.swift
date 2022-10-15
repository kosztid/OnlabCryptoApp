import Foundation

class RegisterScreenInteractor {
    let model: DataModel

    init(model: DataModel) {
        self.model = model
    }
    func register(email: String, password: String) {
        model.register(email: email, password: password)
    }
    func setregistererrorfalse() {
        model.registererror = false
    }
    func setregisteredfalse() {
        model.registererror = false
    }
}
