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
        return userService.getUserId()
    }
    func getAccountEmail() -> String {
        return userService.getUserEmail()
    }
    
    func issignedin() -> Bool {
        return userService.isSignedIn
    }
    func sendPhoto(image: UIImage, message: MessageModel, id: String) {
     // TODO:   model.sendPhoto(image: image, message: message, communityid: id)
    }
}
