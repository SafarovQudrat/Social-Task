import UIKit

class PostViewModel {
    
    func fetchPosts(complation:@escaping ([PostDM])->Void){
        
        APIService.shared.fetchData(url: Endpoints.posts.rawValue) { result in
            switch result {
            case .success(let data):
                do {
                    let posts = try? JSONDecoder().decode([PostDM].self, from: data)
                    guard let posts = posts else {return}
                    DispatchQueue.main.async {
                        for i in posts {
                            CoreDataManager.shared.addPost(post: i)
                        }
    
                    }
                    complation(posts)
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                complation([])
            }
        }
    }
    
    func fetchComment(complation:@escaping ([CommentDM])->Void){
        APIService.shared.fetchData(url: Endpoints.comments.rawValue) { result in
            switch result {
            case .success(let data):
                do {
                    let comment = try? JSONDecoder().decode([CommentDM].self, from: data)
                    guard let comment = comment else {return}
                    DispatchQueue.main.async {
                        for i in comment {
                            CoreDataManager.shared.addComment(i)
                        }
                        
                    }
                    complation(comment)
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
               complation([])
            }
        }
        
    }
    
    func fetchUser(complation:@escaping ([UserDM])->Void){
        APIService.shared.fetchData(url: Endpoints.users.rawValue) { result in
            switch result {
            case .success(let data):
                do {
                    let user = try? JSONDecoder().decode([UserDM].self, from: data)
                    guard let user = user else {return}
                    DispatchQueue.main.async {
                        for i in user {
                            CoreDataManager.shared.addUser(i)
                        }
                        
                    }
                    complation(user)
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
               complation([])
            }
        }
    }
}
