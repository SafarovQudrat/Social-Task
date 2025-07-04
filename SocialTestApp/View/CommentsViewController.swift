import UIKit

class CommentsViewController: UIViewController {
    
    private var tableView: UITableView = {
        let t = UITableView()
        t.register(CommentCell.self, forCellReuseIdentifier: CommentCell.identifier)
        return t
    }()
    var comments:[CommentDM] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Comments"
        self.view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }
    
    
}

extension CommentsViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.identifier, for: indexPath) as? CommentCell else {return UITableViewCell()}
        cell.configureComment(comments[indexPath.row])
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        150
//    }
}
