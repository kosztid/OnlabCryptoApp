import Foundation
import SwiftUI

class MessagerPresenter: ObservableObject {
    private let interactor: MessagerInteractor
    @Published var community: CommunityModel
    private let router = MessagerRouter()

    init(interactor: MessagerInteractor, community: CommunityModel) {
        self.interactor = interactor
        self.community = community
    }

    func messagesGet() -> [MessageModel] {
        community.messages
    }
    func getAccountInfo() -> String {
        interactor.getAccountInfo()
    }
    func issignedin() -> Bool {
        interactor.issignedin()
    }
    func usersGet() -> [String] {
        community.members
    }
    func makeButtonForUsers() -> some View {
        NavigationLink(Strings.members, destination: router.makeMembersView(community: self.community))
            .buttonStyle(UnifiedBorderedButtonStyle())
    }
    func sendmessage(message: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Strings.dateformat
        let stringdate = dateFormatter.string(from: Date())
        let email = interactor.getAccountEmail()
        let message = MessageModel(id: 1, sender: interactor.getAccountInfo(), senderemail: email, message: message, time: stringdate, image: false)
        self.interactor.sendMessage(id: community.id, message: message)
    }
    func sendPhoto(image: UIImage) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Strings.dateformat
        let stringdate = dateFormatter.string(from: Date())
        let email = interactor.getAccountEmail()
        let message = MessageModel(id: 1, sender: interactor.getAccountInfo(), senderemail: email, message: "lateinit", time: stringdate, image: true)
        interactor.sendPhoto(image: image, message: message, id: community.id)
    }
}
