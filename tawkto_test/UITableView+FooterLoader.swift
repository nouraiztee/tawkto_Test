//
//  UITableView+FooterLoader.swift
//  tawkto_test
//
//  Created by Nouraiz Taimour on 02/08/2024.
//

import Foundation

import UIKit

extension UITableView {
  func showLoadingFooter() {
      let spinner = UIActivityIndicatorView(style: .medium)
    spinner.startAnimating()
    spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: self.bounds.width, height: CGFloat(44))

    self.tableFooterView = spinner
    self.tableFooterView?.isHidden = false
  }
  
  func hideLoadingFooter() {
    self.tableFooterView?.isHidden = true
    self.tableFooterView = nil
  }
}
