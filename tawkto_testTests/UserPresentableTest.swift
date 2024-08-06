//
//  UserPresentableTest.swift
//  tawkto_testTests
//
//  Created by Nouraiz Taimour on 06/08/2024.
//

import XCTest
@testable import tawkto_test

final class UserPresentableTest: XCTestCase {
    
    var mockUser: GitHubUserPresentable!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockUser = getMockUser()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetUserID() throws {
        XCTAssertEqual(mockUser.getUserID(), 6)
    }
    
    func testGetUsername() throws {
        XCTAssertEqual(mockUser.getUsername(), "ivey")
    }
    
    func testGetProfileUrl() throws {
        XCTAssertEqual(mockUser.getProfileUrl(), "https://api.github.com/users/ivey")
    }
    
    
    func testGetFollowersCount() throws {
        XCTAssertEqual(mockUser.getFollowersCount(), 154)
    }
    
    func testGetFollowingCount() throws {
        XCTAssertEqual(mockUser.getFollowingCount(), 3)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    private func getMockUser() -> GitHubUserPresentable {
        let pathString = Bundle(for: type(of: self)).path(forResource: "GithubUserDetail", ofType: "json")!
        let url = URL(fileURLWithPath: pathString)
        let jsonData = try! Data(contentsOf: url)
        let users = try! JSONDecoder().decode(GitHubUserAPIModel.self, from: jsonData)
        
        return GitHubUserPresentable(userModel: users.gitHubUser)
    }

}
