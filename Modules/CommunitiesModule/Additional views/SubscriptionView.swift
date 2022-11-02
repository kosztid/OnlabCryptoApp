import SwiftUI

struct SubscriptionView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let action: (String) -> Void
    let subbedList: [String]
    var list: [UserModel]

    var body: some View {
        List {
            ForEach(list) { user in
                HStack {
                    Text(user.email)
                    Spacer()
                    Button {
                        action(user.id)
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text(subbedList.contains {$0 == user.id} ? "Unsubscribe" : "Subscribe")
                    }
                }
            }
        }
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
