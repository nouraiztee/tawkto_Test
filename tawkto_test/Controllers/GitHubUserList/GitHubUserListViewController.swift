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
    
    let reachability = try! Reachability()
    var noConnectionView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Github Users"
        
        userListTableView.dataSource = self
        userListTableView.delegate = self
        
        seacrhBar.delegate = self
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
           do{
             try reachability.startNotifier()
           }catch{
             print("could not start reachability notifier")
           }
        
        addNoConnectionView()
        hideNoConnectionView()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)

    }
    
    @objc func reachabilityChanged(note: Notification) {

      let reachability = note.object as! Reachability

      switch reachability.connection {
      case .unavailable:
          showNoConnectionView(withConnection: false)
          break
      case .cellular, .wifi:
          showNoConnectionView(withConnection: true)
       break
      }
    }

    private func addNoConnectionView() {
        noConnectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(noConnectionView)
        NSLayoutConstraint.activate([
            noConnectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noConnectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            noConnectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            noConnectionView.heightAnchor.constraint(equalToConstant: 40)
        ])
        noConnectionView.backgroundColor = .red
        let label = UILabel()
        label.textColor = .white
        label.text = "No internet connection"
        label.translatesAutoresizingMaskIntoConstraints = false
        noConnectionView.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: noConnectionView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: noConnectionView.centerYAnchor)
        ])
        self.view.addSubview(noConnectionView)
    }
    
    private func hideNoConnectionView() {
        noConnectionView.isHidden = true
    }
    
    private func showNoConnectionView(withConnection: Bool) {
        if withConnection {
            noConnectionView.backgroundColor = .green
            (noConnectionView.subviews.last as! UILabel).text = "Connected"
        }else {
            noConnectionView.backgroundColor = .red
            (noConnectionView.subviews.last as! UILabel).text = "No internet connection"
        }
        UIView.animate(withDuration: 2) {
            self.noConnectionView.isHidden = false
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
        if indexPath.row == (usersViewModel.usersList?.count ?? 0) - 1 {
            usersViewModel.getUsers(sinceID: usersViewModel.usersList?.last?.getUserID() ?? 0)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let userName = usersViewModel.getUserDataSource()?[indexPath.row].getUsername() else { return }
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GitHubUserDetailsViewController") as! GitHubUserDetailsViewController
        vc.userName = userName
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



