import UIKit
import SDWebImage
protocol SocialCellDelegate: AnyObject {
    func didTapLike(on cell: SocialCell)
    func didTapComment(on cell: SocialCell)
}


class SocialCell: UITableViewCell {
    
    static var identifier = "SocialCell"
    
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
    
     let titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        lbl.font = .boldSystemFont(ofSize: 17)
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

     let imageV: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "carImage")
        image.clipsToBounds = true
        return image
    }()
    
    private let likeBtn: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.tintColor = .gray
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    private let commentBtn: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "bubble.left"), for: .normal)
        button.setTitle("  5", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.tintColor = .label
        button.contentHorizontalAlignment = .left
        return button
    }()
    
     lazy var btnStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [likeBtn, commentBtn])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    weak var delegate: SocialCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUi()
        setUpActions()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpUi()
    }
    
    private func setUpUi() {
        contentView.addSubview(profileImage)
        contentView.addSubview(usernameLbl)
        contentView.addSubview(titleLbl)
        contentView.addSubview(bodyLbl)
        contentView.addSubview(imageV)
        contentView.addSubview(btnStack)

        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            profileImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            profileImage.heightAnchor.constraint(equalToConstant: 30),
            profileImage.widthAnchor.constraint(equalToConstant: 30),

            usernameLbl.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            usernameLbl.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 12),
            usernameLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            titleLbl.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 12),
            titleLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            bodyLbl.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 4),
            bodyLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            bodyLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            imageV.topAnchor.constraint(equalTo: bodyLbl.bottomAnchor, constant: 12),
            imageV.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageV.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageV.heightAnchor.constraint(equalToConstant: 300),

            btnStack.topAnchor.constraint(equalTo: imageV.bottomAnchor, constant: 12),
            btnStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            btnStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            btnStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            btnStack.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    private func setUpActions() {
        likeBtn.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        commentBtn.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
    }

    @objc private func handleLike() {
        delegate?.didTapLike(on: self)
    }

    @objc private func handleComment() {
        delegate?.didTapComment(on: self)
    }

    func configure(_ post:PostDM,_ user:UserDM?,_ commentCount:Int){
        profileImage.sd_setImage(with: user?.avatarURL)
        usernameLbl.text = user?.username
        titleLbl.text = post.title
        bodyLbl.text = post.body
        imageV.sd_setImage(with: post.imageURL)
        commentBtn.setTitle("\(commentCount)", for: .normal)
        if post.isLiked ?? false {
            likeBtn.tintColor = .red
            likeBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }else {
            likeBtn.tintColor = .label
            likeBtn.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    

}
