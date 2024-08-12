//
//  ViewController.swift
//  tawkto_test
//
//  Created by Nouraiz Taimour on 30/07/2024.
//

import UIKit
import SwiftUI
import Network

protocol GitHubUserDetailsViewControllerDelegate: AnyObject {
    func didPopUSerDetailVC(withNote: String, userName: String)
}

class GitHubUserListViewController: UIViewController {

    @IBOutlet weak var userListTableView: UITableView!
    @IBOutlet weak var seacrhBar: UISearchBar!
    
    var usersViewModel = UserListViewModel(apiService: GitHubUsersAPIClient(), localStorageService: CoreDataClient.shared)
    private var noInternetBanner: NoInternetBannerView!
    
    let reachability = try! Reachability()
    
    var isFirstLaunch = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Github Users"
        
        userListTableView.dataSource = self
        userListTableView.delegate = self
        
        seacrhBar.delegate = self
        
        registerCell()
        
        setupRecheability()
        setupNoInternetBanner()
        
        usersViewModel.usersList?.removeAll()
        usersViewModel.setSearch(isSeacrhing: false)
        usersViewModel.getUsers()
        
        //viewmodel binding
        usersViewModel.didFetchUsersList = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.userListTableView.reloadData()
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    private func registerCell() {
        userListTableView.registerCells([
            GitHubUserListTableViewCell.self,
            GitHubUserInvertedTableViewCell.self,
            GitHubUserNoteTableViewCell.self,
            GitHubUserNoteInvertedTableViewCell.self
        ])
    }
    
    private func setupNoInternetBanner() {
           noInternetBanner = NoInternetBannerView()
           noInternetBanner.translatesAutoresizingMaskIntoConstraints = false
           noInternetBanner.isHidden = true
           view.addSubview(noInternetBanner)
           
           NSLayoutConstraint.activate([
               noInternetBanner.leadingAnchor.constraint(equalTo: view.leadingAnchor),
               noInternetBanner.trailingAnchor.constraint(equalTo: view.trailingAnchor),
               noInternetBanner.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
               noInternetBanner.heightAnchor.constraint(equalToConstant: 50)
           ])
       }
    
    func setupRecheability() {
        reachability.whenReachable = { reachability in
            if self.isFirstLaunch {
                self.isFirstLaunch = false
                return
            }
            self.showRestoredInternetBanner()
            self.usersViewModel.getUsers()
        }
        reachability.whenUnreachable = { _ in
            self.showNoInternetBanner()
        }

        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
       
       private func showNoInternetBanner() {
           noInternetBanner.updateBanner(message: "No Internet Connection", backgroundColor: .red)
           noInternetBanner.isHidden = false
           
           // Hide the banner after 2 seconds
           DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                   self?.noInternetBanner.isHidden = true
           }
       }
       
       private func showRestoredInternetBanner() {
           noInternetBanner.updateBanner(message: "Internet Connection Restored", backgroundColor: .green)
           noInternetBanner.isHidden = false
           
           // Hide the banner after 2 seconds
           DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
               self?.noInternetBanner.isHidden = true
           }
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
        if reachability.connection == .unavailable {
            return
        }
        
        if indexPath.row == (usersViewModel.usersList?.count ?? 0) - 1 {
            usersViewModel.getUsers(sinceID: usersViewModel.usersList?.last?.getUserID() ?? 0)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if reachability.connection == .unavailable {
            return
        }
        
        guard let userName = usersViewModel.getUserDataSource()?[indexPath.row].getUsername() else { return }
        
        var userDetailView = GithubUserDetailView()
        userDetailView.userName = userName
        userDetailView.userAvatarURL = usersViewModel.getUserDataSource()?[indexPath.row].getAvatarUrl() ?? ""
        userDetailView.userNote = usersViewModel.getUserDataSource()?[indexPath.row].getNote() ?? ""
        userDetailView.delegate = self
        let vc = UIHostingController(rootView: userDetailView)
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
    func didPopUSerDetailVC(withNote: String, userName: String) {
            let index = self.usersViewModel.usersList?.firstIndex(where: {$0.getUsername().lowercased() == userName})
            usersViewModel.usersList?[index!].set(note: withNote)
        
        userListTableView.reloadData()
    }
}

