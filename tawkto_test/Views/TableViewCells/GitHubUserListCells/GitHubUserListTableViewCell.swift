//
//  GitHubUserListTableViewCell.swift
//  tawkto_test
//
//  Created by Nouraiz Taimour on 31/07/2024.
//

import Foundation
import UIKit

protocol UserCustomCell {
    func configure(withDataModel model: GitHubUserCellViewModel?)
}

class GitHubUserListTableViewCell: UITableViewCell, UserCustomCell {
    
    // Define the UI elements
        let userAvatarImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            return imageView
        }()
        
        let userNameLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.boldSystemFont(ofSize: 16)
            return label
        }()
        
        let profileUrlLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.systemFont(ofSize: 14)
            label.textColor = .gray
            return label
        }()
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            // Add the UI elements to the content view
            contentView.addSubview(userAvatarImageView)
            contentView.addSubview(userNameLabel)
            contentView.addSubview(profileUrlLabel)
            
            // Add constraints to the UI elements
            NSLayoutConstraint.activate([
                // Constraints for customImageView
                userAvatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                userAvatarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                userAvatarImageView.widthAnchor.constraint(equalToConstant: 50),
                userAvatarImageView.heightAnchor.constraint(equalToConstant: 50),
                
                // Constraints for titleLabel
                userNameLabel.leadingAnchor.constraint(equalTo: userAvatarImageView.trailingAnchor, constant: 10),
                userNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                userNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                
                // Constraints for subtitleLabel
                profileUrlLabel.leadingAnchor.constraint(equalTo: userAvatarImageView.trailingAnchor, constant: 10),
                profileUrlLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                profileUrlLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 5),
                profileUrlLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
            ])
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    
    func configure(withDataModel model: GitHubUserCellViewModel?) {
        guard let dataModel = model else { return }
        userNameLabel.text = dataModel.getUsername()
        profileUrlLabel.text = dataModel.getProfileUrl()
        
    }
}

extension GitHubUserListTableViewCell: ReusableCell {}


