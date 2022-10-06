import Foundation
import Combine

class CommunityService {
    @Published var communities: [MessageGroupModel] = []
    var communitySub: AnyCancellable?
    
    func sendMessage(_ apikey: String, _ communityID: String, _ message: MessageModel) {
        guard let url = URL(string: "http://localhost:8080/api/v1/communities/\(communityID)") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
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
            self.loadCommunities(apikey: apikey)
        }
        task.resume()
    }

    func loadCommunities(apikey: String) {
        let baseUrl = "http://localhost:8080/api/v1/communities"
        guard let url = URL(string: "\(baseUrl)")
        else {
            return
        }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        communitySub = URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { (output) -> Data in
                guard let response = output.response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode < 300 else {

                          throw URLError(.badServerResponse)
                      }
                return output.data
            }
            .receive(on: DispatchQueue.main)
            .decode(type: [MessageGroupModel].self, decoder: JSONDecoder())
            .sink {(completion) in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] (community) in
                print(community)
                self?.communities = community
                for index in 0...(community.count - 1) {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    self?.communities[index].messages.sort {
                        dateFormatter.date(from: $0.time)! < dateFormatter.date(from: $1.time)!
                    }
                    if let id = self?.communities[index].messages.last?.id {
                        self?.communities[index].lastid = id
                        print(id)
                    }
                }
                self?.communitySub?.cancel()
            }
    }

    func addCommunity(_ apikey: String, _ communityName: String) {
        guard let url = URL(string: "http://localhost:8080/api/v1/communities/") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
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
            self.loadCommunities(apikey: apikey)
        }
        task.resume()
    }
}
