//
//  GitHubUserNoteInvertedTableViewCell.swift
//  tawkto_test
//
//  Created by Nouraiz Taimour on 31/07/2024.
//

import Foundation
import UIKit

class GitHubUserNoteInvertedTableViewCell: GitHubUserNoteTableViewCell {
    override func configure(withDataModel model: GitHubUserCellViewModel?) {
        super.configure(withDataModel: model)
        
        guard let dataModel = model else { return }
        ImageLoader.shared.loadData(url: URL(string: dataModel.getAvatarUrl())!) { data, error in
            guard let data = data else { return }
            DispatchQueue.main.async { [weak self] in
                let image = UIImage(data: data)
                self?.invertImage(image: image)
                self?.userAvatarImageView.layer.cornerRadius = (self?.userAvatarImageView.frame.height ?? 0) / 2
            }
        }
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
