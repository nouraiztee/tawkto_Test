//
//  GitHubUserNoteTableViewCell.swift
//  tawkto_test
//
//  Created by Nouraiz Taimour on 31/07/2024.
//

import Foundation
import UIKit

class GitHubUserNoteTableViewCell: GitHubUserListTableViewCell {
    let noteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Add the UI elements to the content view
        contentView.addSubview(noteImageView)
        
        NSLayoutConstraint.activate([
            // Constraints for customImageView
            noteImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 8),
            noteImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            noteImageView.widthAnchor.constraint(equalToConstant: 25),
            noteImageView.heightAnchor.constraint(equalToConstant: 25),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure(withDataModel model: GitHubUserCellViewModel) {
        
    }
}
