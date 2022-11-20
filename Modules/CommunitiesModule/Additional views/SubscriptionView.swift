import SwiftUI

struct SubscriptionView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let action: (String) -> Void
    let subbedList: [String]
    var list: [UserModel]

    var body: some View {
        List {
            ForEach(list) { user in
                ZStack {
                    Color.theme.backgroundcolor
                        .ignoresSafeArea()
                    HStack {
                        Text(user.email)
                            .foregroundColor(user.visibility ? Color.accentColor : Color.gray)
                        Spacer()
                        Button {
                            action(user.id)
                            self.presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text(subbedList.contains {$0 == user.id} ? Strings.unsubscribe : Strings.subscribe)
                        }
                    }
                }
            }
            .listRowSeparatorTint(Color.theme.backgroundsecondary)
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        }
        .background(Color.theme.backgroundcolor)
        .scrollContentBackground(.hidden)
        .navigationBarTitleDisplayMode(.inline)
    }

    init(_ list: [UserModel] = [], _ sList: [String] = [], _ action: @escaping (String) -> Void = {_ in }) {
        self.list = list
        self.subbedList = sList
        self.action = action
    }
}

struct SubscriptionView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionView()
    }
}
