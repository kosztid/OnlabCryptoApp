import SwiftUI

struct MessageGroupMembersView: View {
    @ObservedObject var presenter: MessageGroupMembersPresenter
    var body: some View {
        ZStack {
            Color.theme.backgroundcolor
                .ignoresSafeArea()
            VStack {
                Text(Strings.groupMembers)
                    .font(.system(size: 20))
                List {
                    ForEach(presenter.community.members, id: \.self) { member in
                        ZStack {
                            Color.theme.backgroundcolor
                                .ignoresSafeArea()
                            Text(member)
                        }
                    }
                    .listRowSeparatorTint(Color.theme.backgroundsecondary)
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                }

                .background(Color.theme.backgroundcolor)
                .scrollContentBackground(.hidden)
                .listStyle(PlainListStyle())
            }
        }
    }
}
