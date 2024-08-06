//
//  ViewController.swift
//  tawkto_test
//
//  Created by Nouraiz Taimour on 30/07/2024.
//

import UIKit

class GitHubUserListViewController: UIViewController {

    @IBOutlet weak var userListTableView: UITableView!
    @IBOutlet weak var seacrhBar: UISearchBar!
    
    var usersViewModel = UserListViewModel(apiService: GitHubUsersAPIClient(), localStorageService: CoreDataClient.shared)
    var noConnectionView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Github Users"
        
        userListTableView.dataSource = self
        userListTableView.delegate = self
        
        seacrhBar.delegate = self
        
        registerCell()
        
        usersViewModel.getUsers()
        
        //viewmodel binding
        usersViewModel.didFetchUsersList = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.userListTableView.reloadData()
            }
        }
    }
    
    private func registerCell() {
        userListTableView.registerCells([
            GitHubUserListTableViewCell.self,
            GitHubUserInvertedTableViewCell.self,
            GitHubUserNoteTableViewCell.self,
            GitHubUserNoteInvertedTableViewCell.self
        ])
    }
}

extension GitHubUserListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        usersViewModel.getUserListCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = usersViewModel.getUserDataSource()?[indexPath.row]
        
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
        guard let userName = usersViewModel.getUserDataSource()?[indexPath.row].getUsername() else { return }
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GitHubUserDetailsViewController") as! GitHubUserDetailsViewController
        vc.userName = userName
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension GitHubUserListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            usersViewModel.setSearch(isSeacrhing: true)
        }else {
            usersViewModel.setSearch(isSeacrhing: false)
        }
        
        usersViewModel.getSearchedUser(withKeyWord: searchText)
    }
}

extension GitHubUserListViewController: GitHubUserDetailsViewControllerDelegate {
    func didPopUSerDetailVC(withChange: Bool) {
        if withChange {
            self.usersViewModel.getUsers()
        }
    }
}



