//
//  GitHubUserDetailsViewController.swift
//  tawkto_test
//
//  Created by Nouraiz Taimour on 04/08/2024.
//

import UIKit

class GitHubUserDetailsViewController: UIViewController {
    
    @IBOutlet weak var userAvatarImage: UIImageView!
    
    @IBOutlet weak var followersCountLbl: UILabel!
    @IBOutlet weak var followingCountLbl: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var companyLbl: UILabel!
    @IBOutlet weak var blogLbl: UILabel!
    
    @IBOutlet weak var notesTxtView: UITextView!
    
    @IBOutlet weak var saveNoteBtn: UIButton!
    
    var userName: String!
    
    var userDetailViewModel: UserDetailsViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        userDetailViewModel = UserDetailsViewModel(apiService: GitHubUsersAPIClient(), userName: userName)
        userDetailViewModel.didFetchUserDetails = { [weak self] user in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.setUpUserData(user: user)
            }
            //followersCountLbl.text = "Followers: \(user.getFollowersCount())"
        }
        userDetailViewModel.getUserDetails()
    }
    
    private func setUpUserData(user: GitHubUserPresentable) {
        followersCountLbl.text = "Followers: \(user.getFollowersCount())"
        followingCountLbl.text = "Following: \(user.getFollowersCount())"
        userNameLbl.text = "\(user.getUsername())"
        companyLbl.text = "\(user.getCompany())"
        blogLbl.text = "\(user.getBlog())"
    }

}
