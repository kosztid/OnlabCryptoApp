import Foundation
import Resolver

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        register { SpringUserService() as UserService}.scope(.application)
        register { SpringCommunityService() as CommunityService}.scope(.application)
    }
}
