import Foundation
import UIKit

class MessagerInteractor {
    private let userService: UserService
    private let communityService: CommunityService

    init(_ user: UserService, _ community: CommunityService) {
        self.userService = user
        self.communityService = community
    }
    func sendMessage(id: String, message: MessageModel) {
        if id != "CbP9VCE4TWEHftzZuL4Q" {
            communityService.sendMessage(id, message)
        }
    }
    func getAccountInfo() -> String {
        userService.getUserId()
    }
    func getAccountEmail() -> String {
        userService.getUserEmail()
    }
    func issignedin() -> Bool {
        userService.isSignedIn
    }
    func sendPhoto(image: UIImage, message: MessageModel, id: String) {
        communityService.sendPhoto(image: image, message: message, communityid: id)
    }
}
