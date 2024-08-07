//
//  GitHubUserDetailsViewController.swift
//  tawkto_test
//
//  Created by Nouraiz Taimour on 04/08/2024.
//

import UIKit
import CoreData

protocol GitHubUserDetailsViewControllerDelegate: AnyObject {
    func didPopUSerDetailVC(withChange: Bool)
}

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
    
    weak var delegate: GitHubUserDetailsViewControllerDelegate?
    var noteHasChanged = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = userName
        notesTxtView.layer.borderWidth = 0.5
        notesTxtView.layer.borderColor = UIColor.gray.cgColor
        
        userDetailViewModel = UserDetailsViewModel(apiService: GitHubUsersAPIClient(), userName: userName, localStorageService: CoreDataClient.shared)
        userDetailViewModel.didFetchUserDetails = { [weak self] user in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.setUpUserData(user: user)
            }
        }
        userDetailViewModel.getUserDetails()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        delegate?.didPopUSerDetailVC(withChange: noteHasChanged)
    }
    
    private func setUpUserData(user: GitHubUserPresentable) {
        followersCountLbl.text = "Followers: \(user.getFollowersCount())"
        followingCountLbl.text = "Following: \(user.getFollowersCount())"
        userNameLbl.text = "Name: \(user.getUsername())"
        companyLbl.text = "Company: \(user.getCompany())"
        blogLbl.text = "Blog: \(user.getBlog())"
        notesTxtView.text = userDetailViewModel.getUserNote(forUserID: userName)
        
        guard let url = URL(string: user.getAvatarUrl()) else { return }
        ImageLoader.shared.loadData(url: url) { data, error in
            if let imageData = data {
                DispatchQueue.main.async { [weak self] in
                    self?.userAvatarImage.image = UIImage(data: imageData)
                }
            }
        }
    }
    
    @IBAction func didTapSaveNote(_ sender: UIButton) {
        let existingNote = userDetailViewModel.getUserNote(forUserID: userName)
        if existingNote == notesTxtView.text || notesTxtView.text.isEmpty {
            return
        }
        userDetailViewModel.saveUserNote(forUserID: userName, note: self.notesTxtView.text)
        noteHasChanged = true
        showSaveAlert()
    }
    
    private func showSaveAlert() {
        let alert = UIAlertController(title: "Success", message: "Note saved succesfully", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
