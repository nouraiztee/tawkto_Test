//
//  ReuseableCell.swift
//  tawkto_test
//
//  Created by Nouraiz Taimour on 31/07/2024.
//

import Foundation

/// A protocol that all reusable cells must implement.
protocol ReusableCell: AnyObject {
    static var cellIdentifier: String { get }
}

// Default protocol implementation
extension ReusableCell {

    static var cellIdentifier: String {
        return String(describing: self)
    }

}
