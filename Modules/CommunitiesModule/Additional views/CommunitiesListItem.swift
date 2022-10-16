import SwiftUI

struct CommunitiesListItem: View {
    var community: CommunityModel
    var body: some View {
        ZStack {
            Color.theme.backgroundsecondary
                .ignoresSafeArea()
            HStack {
                Text(community.name)
                    .foregroundColor(Color.theme.accentcolor)
            }
        }
    }
}
struct CommunitiesListItem_Previews: PreviewProvider {
    static var previews: some View {
// swiftlint:disable:next line_length
        CommunitiesListItem(community: CommunityModel(id: "1", name: "Bitcoin Community", messages: [MessageModel(id: 1, sender: "Dominik", senderemail: "mail", message: "Első üzenet", time: "2022-02-02", image: false), MessageModel(id: 1, sender: "Dominik", senderemail: "mail", message: "Második üzenetMásodik üzenetMásodik üzenetMásodik üzenetMásodik üzenetMásodik üzenetMásodik üzenetMásodik üzenet", time: "2022-02-02", image: false), MessageModel(id: 1, sender: "Dominik", senderemail: "email", message: "Harmadik üzenet", time: "2022-02-02", image: false)], members: ["szia"], lastid: 1))
    }
}
