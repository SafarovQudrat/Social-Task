import UIKit

struct PostDM:Decodable {
    let id: Int?
    let userId: Int?
    let title: String?
    let body: String?
    let isLiked:Bool?
    var imageURL: URL {
        return URL(string: "https://picsum.photos/400/300?random=\(String(describing: id))")!
    }
}

extension PostDM {
    init?(from coreDataModel: PostCD) {
        guard
            let title = coreDataModel.title,
            let body = coreDataModel.body
        else { return nil }
        
        self.id = Int(coreDataModel.id)
        self.userId = Int(coreDataModel.userID)
        self.title = title
        self.body = body
        self.isLiked = coreDataModel.isLiked
    }
}

struct CommentDM:Codable {
    var postId:Int
    var id:Int
    var name:String
    var email:String
    var body:String
}

struct UserDM: Codable {
    let id: Int?
    let name: String?
    let username: String?
    let email: String?
    let address: Address?
    let phone: String?
    let website: String?
    let company: Company?
    var avatarURL: URL {
        return URL(string: "https://picsum.photos/400/300?random=\(String(describing: id))")!
    }
}

struct Address: Codable {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
    let geo: Geo
}

struct Geo: Codable {
    let lat: String
    let lng: String
}

struct Company: Codable {
    let name: String
    let catchPhrase: String
    let bs: String
}
