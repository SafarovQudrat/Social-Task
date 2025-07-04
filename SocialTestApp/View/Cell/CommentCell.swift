import UIKit

class CommentCell: UITableViewCell {
    
    static var identifier = "CommentCell"
    
    private let profileImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.image = UIImage(named: "image")
        image.layer.cornerRadius = 15
        return image
    }()
    
    private let usernameLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .gray
        lbl.font = .systemFont(ofSize: 17, weight: .medium)
        return lbl
    }()
    
    private let bodyLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .gray
        lbl.numberOfLines = 0
        
        lbl.font = .systemFont(ofSize: 15)
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUi()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpUi()
    }
    
    private func setUpUi() {
        contentView.addSubview(profileImage)
        contentView.addSubview(usernameLbl)
        contentView.addSubview(bodyLbl)

        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            profileImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            profileImage.heightAnchor.constraint(equalToConstant: 30),
            profileImage.widthAnchor.constraint(equalToConstant: 30),

            usernameLbl.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            usernameLbl.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 12),
            usernameLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            bodyLbl.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 10),
            bodyLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            bodyLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            bodyLbl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func configureComment(_ comment:CommentDM){
        profileImage.sd_setImage(with: URL(string: "https://picsum.photos/400/300?random=\(String(describing: comment.id))")!)
        usernameLbl.text = comment.email
        bodyLbl.text = comment.body
    }
}
