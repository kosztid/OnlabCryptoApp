import Foundation
import Resolver

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        // MARK: - Production, UI
        register { SpringUserService() as UserService}.scope(.application)
        register { SpringCommunityService() as CommunityService}.scope(.application)
        // MARK: - UNIT Testings
//        register { TestUserService() as UserService}.scope(.application)
//        register { TestCommunityService() as CommunityService}.scope(.application)
    }
}
