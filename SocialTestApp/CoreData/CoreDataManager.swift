import UIKit
import CoreData

class CoreDataManager {
    
    public static let shared = CoreDataManager()
    
    private init() {}
    
    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //    MARK: Post
    func addPost(post: PostDM) {
        let fetchRequest: NSFetchRequest<PostCD> = PostCD.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", post.id ?? 0)
        
        if let existing = try? context.fetch(fetchRequest), !existing.isEmpty {
            return // allaqachon saqlangan
        }
        guard let entity = NSEntityDescription.entity(forEntityName: "PostCD", in: context) else {return}
        let postCD = PostCD(entity: entity, insertInto: context)
        postCD.id = Int16(post.id ?? 0)
        postCD.userID = Int16(post.userId ?? 0)
        postCD.title = post.title
        postCD.body = post.body
        postCD.imageUrl = post.imageURL.absoluteString
        postCD.isLiked = post.isLiked ?? false
        appDelegate.saveContext()
    }
    
    func fetchPosts() -> [PostDM] {
        let request: NSFetchRequest<PostCD> = PostCD.fetchRequest()
        do {
            let postsCD = try context.fetch(request)
            return postsCD.map { postCD in
                PostDM(
                    id: Int(postCD.id),
                    userId: Int(postCD.userID),
                    title: postCD.title,
                    body: postCD.body,
                    isLiked: postCD.isLiked
                )
            }
        } catch {
            print("❌ Error fetching posts: \(error.localizedDescription)")
            return []
        }
    }
    
    func toggleLikeStatus(for postId: Int) {
        let fetchRequest: NSFetchRequest<PostCD> = PostCD.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", postId)
        
        do {
            if let post = try context.fetch(fetchRequest).first {
                post.isLiked.toggle()
                appDelegate.saveContext()
                print("✅ isLiked now: \(post.isLiked)")
            } else {
                print("❌ Post topilmadi (id: \(postId))")
            }
        } catch {
            print("❌ Xatolik: \(error.localizedDescription)")
        }
    }
    
    //    MARK: Comment
    func addComment(_ comment: CommentDM) {
        let request: NSFetchRequest<CommentCD> = CommentCD.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", comment.id)
        
        if let existing = try? context.fetch(request), !existing.isEmpty {
            return // allaqachon mavjud
        }
        
        guard let entity = NSEntityDescription.entity(forEntityName: "CommentCD", in: context) else { return }
        let commentCD = CommentCD(entity: entity, insertInto: context)
        commentCD.id = Int16(comment.id)
        commentCD.postID = Int16(comment.postId)
        commentCD.name = comment.name
        commentCD.email = comment.email
        commentCD.body = comment.body
        appDelegate.saveContext()
    }
    
    func fetchComments() -> [CommentDM] {
        let request: NSFetchRequest<CommentCD> = CommentCD.fetchRequest()
        
        do {
            let commentCDs = try context.fetch(request)
            return commentCDs.map { comment in
                CommentDM(
                    postId: Int(comment.postID),
                    id: Int(comment.id),
                    name: comment.name ?? "",
                    email: comment.email ?? "",
                    body: comment.body ?? ""
                )
            }
        } catch {
            print("❌ Comment fetch xatoligi: \(error.localizedDescription)")
            return []
        }
    }
    //    MARK: User
    func addUser(_ user: UserDM) {
        let request: NSFetchRequest<UserCD> = UserCD.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", user.id ?? 0)
        
        if let existing = try? context.fetch(request), !existing.isEmpty {
            return // allaqachon mavjud
        }
        let userCD = UserCD(context: context)
        userCD.name = user.name
        userCD.email = user.email
        userCD.id = Int16(user.id ?? 0)
        userCD.phone = user.phone
        userCD.username = user.username
    }
    
    func fetchUser() -> [UserDM] {
        let request: NSFetchRequest<UserCD> = UserCD.fetchRequest()
        do {
            let userCD = try context.fetch(request)
            return userCD.map { user in
                UserDM(id: Int(user.id), name: user.name, username: user.username, email: user.email,address: nil, phone: user.phone,website: nil,company: nil)
            }
            
        } catch {
            print("❌ User fetch xatoligi: \(error.localizedDescription)")
            return []
        }
    }
    
}
