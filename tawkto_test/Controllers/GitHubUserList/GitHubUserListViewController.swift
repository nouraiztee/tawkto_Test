//
//  ViewController.swift
//  tawkto_test
//
//  Created by Nouraiz Taimour on 30/07/2024.
//

import UIKit

class GitHubUserListViewController: UIViewController {

    @IBOutlet weak var userListTableView: UITableView!
    
    var usersViewModel = UserListViewModel(apiService: GitHubUsersAPIClient())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        userListTableView.dataSource = self
        userListTableView.delegate = self
        
        userListTableView.registerCells([
            GitHubUserListTableViewCell.self,
            GitHubUserInvertedTableViewCell.self,
            GitHubUserNoteTableViewCell.self,
            GitHubUserNoteInvertedTableViewCell.self
        ])
        
        usersViewModel.getUsers()
        usersViewModel.didFetchUsersList = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.userListTableView.reloadData()
            }
        }
    }

}

extension GitHubUserListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        usersViewModel.usersList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = usersViewModel.usersList?[indexPath.row]
        
        guard let cell = model?.dequeueCell(tableView: tableView, indexPath: indexPath) else {
            return UITableViewCell()
        }
        cell.configure(withDataModel: model)
        
        return cell as! UITableViewCell
    }
}

extension GitHubUserListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (usersViewModel.usersList?.count ?? 0) - 1 {
            usersViewModel.getUsers(sinceID: usersViewModel.usersList?.last?.getUserID() ?? 0)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let userName = usersViewModel.usersList?[indexPath.row].getUsername() else { return }
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GitHubUserDetailsViewController") as! GitHubUserDetailsViewController
        vc.userName = userName
        self.navigationController?.pushViewController(vc, animated: true)
    }
}



