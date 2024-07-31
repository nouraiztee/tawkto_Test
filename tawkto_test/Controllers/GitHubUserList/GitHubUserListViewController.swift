//
//  ViewController.swift
//  tawkto_test
//
//  Created by Nouraiz Taimour on 30/07/2024.
//

import UIKit

class GitHubUserListViewController: UIViewController {

    @IBOutlet weak var userListTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        userListTableView.dataSource = self
        userListTableView.delegate = self
        
        userListTableView.registerCells([
            GitHubUserListTableViewCell.self
        ])
    }

}

extension GitHubUserListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GitHubUserListTableViewCell.cellIdentifier, for: indexPath) as? UserCustomCell
        
        return cell as! UITableViewCell
    }
}

extension GitHubUserListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}



