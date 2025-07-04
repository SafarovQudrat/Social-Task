import UIKit

class PostViewController: UIViewController {
    
    private var tableView: UITableView = {
        let t = UITableView()
        
        t.register(SocialCell.self, forCellReuseIdentifier: SocialCell.identifier)
        return t
    }()
    private var refreshControl = UIRefreshControl()
    private var viewModel = PostViewModel()
    var posts:[PostDM] = []
    var comment:[CommentDM] = []
    var user:[UserDM] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apparenceSettings()
        fetchAllData()
    }
   
    
    func apparenceSettings(){
        navigationItem.title = "SocialGramm"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        self.view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.frame = view.bounds
        refreshControl.addTarget(self, action: #selector(pageRefreshed), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    func fetchAllData(){
        refreshControl.beginRefreshing()
        if CoreDataManager.shared.fetchPosts().isEmpty {
            viewModel.fetchPosts { post in
                self.posts = post
                self.tableView.reloadData()
            }
        }else {
            posts = CoreDataManager.shared.fetchPosts()
            tableView.reloadData()
        }
        if CoreDataManager.shared.fetchComments().isEmpty {
            viewModel.fetchComment { comment in
                self.comment = comment
                self.tableView.reloadData()
            }
        }else {
            comment = CoreDataManager.shared.fetchComments()
            tableView.reloadData()
        }
        if CoreDataManager.shared.fetchUser().isEmpty {
            viewModel.fetchUser { user in
                self.user = user
                self.tableView.reloadData()
            }
        }else {
            user = CoreDataManager.shared.fetchUser()
            tableView.reloadData()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.refreshControl.endRefreshing()
        }
       
    }
    
    @objc func pageRefreshed(){
        fetchAllData()
    }
    
    
    
}
extension PostViewController:UITableViewDelegate,UITableViewDataSource,SocialCellDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SocialCell.identifier, for: indexPath) as? SocialCell else {return UITableViewCell()}
        cell.delegate = self
         let filteredUser = user.first(where: { $0.id == posts[indexPath.row].userId })
        
        let comments = comment.filter{$0.postId == posts[indexPath.row].id}
        cell.configure(posts[indexPath.row], filteredUser, comments.count)
        return cell
    }
    
//    Like Button Function
    
    func didTapLike(on cell: SocialCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        CoreDataManager.shared.toggleLikeStatus(for: posts[indexPath.row].id ?? 0)
        posts = CoreDataManager.shared.fetchPosts()
        tableView.reloadData() 
    }
//    Comment Button
    func didTapComment(on cell: SocialCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        let comments = comment.filter{$0.postId == posts[indexPath.row].id}
        let vc = CommentsViewController()
        vc.comments = comments
        vc.modalPresentationStyle = .pageSheet
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium()]
               sheet.prefersGrabberVisible = true
               sheet.preferredCornerRadius = 20
              sheet.prefersScrollingExpandsWhenScrolledToEdge = false
           }
           
           present(UINavigationController(rootViewController: vc), animated: true)
    }

}
