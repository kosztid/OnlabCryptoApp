import Foundation
import Combine
import FirebaseAuth


class CommunityService {
    let port = "8090"
    @Published var communities: [CommunityModel] = []
    let auth: Auth
    var communitySub: AnyCancellable?

    init() {
        self.auth = Auth.auth()
        loadCommunities()
    }
    
    func sendMessage(_ communityID: String, _ message: MessageModel) {
        self.auth.currentUser?.getIDTokenForcingRefresh(true) { apikey, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let url = URL(string: "http://localhost:\(self.port)/api/v1/communities/\(communityID)") else {
                return
            }
            let token = apikey ?? ""

            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let body: [String: AnyHashable] = [
                "image": message.image,
                "message": message.message,
                "sender": message.sender,
                "senderemail": message.senderemail,
                "time": message.time
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
            let task = URLSession.shared.dataTask(with: request) { _, _, error in
                guard error == nil else {
                    return
                }
                self.loadCommunities()
            }
            task.resume()
        }
    }

    func loadCommunities() {
        self.auth.currentUser?.getIDTokenForcingRefresh(true) { apikey, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            let token = apikey ?? ""
            let baseUrl = "http://localhost:\(self.port)/api/v1/communities"
            guard let url = URL(string: "\(baseUrl)")
            else {
                return
            }
            var request = URLRequest(url: url)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            self.communitySub = URLSession.shared.dataTaskPublisher(for: request)
                .subscribe(on: DispatchQueue.global(qos: .default))
                .tryMap { (output) -> Data in
                    guard let response = output.response as? HTTPURLResponse,
                          response.statusCode >= 200 && response.statusCode < 300 else {

                              throw URLError(.badServerResponse)
                          }
                    return output.data
                }
                .receive(on: DispatchQueue.main)
                .decode(type: [CommunityModel].self, decoder: JSONDecoder())
                .sink {(completion) in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                } receiveValue: { [weak self] (community) in

                    self?.communities = community
                    for index in 0...(community.count - 1) {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        self?.communities[index].messages.sort {
                            dateFormatter.date(from: $0.time)! < dateFormatter.date(from: $1.time)!
                        }
                        if let id = self?.communities[index].messages.last?.id {
                            self?.communities[index].lastid = id
                        }
                    }
                    self?.communitySub?.cancel()
                }
        }


    }

    func addCommunity(_ communityName: String) {
        self.auth.currentUser?.getIDTokenForcingRefresh(true) { apikey, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let url = URL(string: "http://localhost:\(self.port)/api/v1/communities/") else {
                return
            }
            let token = apikey ?? ""

            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let body: [String: AnyHashable] = [
                "id": UUID().uuidString,
                "name": communityName
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
            let task = URLSession.shared.dataTask(with: request) { _, _, error in
                guard error == nil else {
                    return
                }
                self.loadCommunities()
            }
            task.resume()
        }

    }
}
