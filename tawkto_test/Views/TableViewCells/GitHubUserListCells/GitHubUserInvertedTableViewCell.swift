//
//  GitHubUserInvertedTableViewCell.swift
//  tawkto_test
//
//  Created by Nouraiz Taimour on 31/07/2024.
//

import Foundation
import UIKit

class GitHubUserInvertedTableViewCell: GitHubUserListTableViewCell {
    override func configure(withDataModel model: GitHubUserCellViewModel?) {
        super.configure(withDataModel: model)
        
        
    }
    
    private func invertImage(image: UIImage?) {
        
        if let filter = CIFilter(name: "CIColorInvert"),
            let image = image,
            let ciimage = CIImage(image: image) {
            
            filter.setValue(ciimage, forKey: kCIInputImageKey)
            let newImage = UIImage(ciImage: filter.outputImage!)
            self.userAvatarImageView.image = newImage
        }
        
    }
}
