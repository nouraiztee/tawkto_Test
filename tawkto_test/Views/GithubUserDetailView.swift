//
//  GithubUserDetailView.swift
//  tawkto_test
//
//  Created by Nouraiz Taimour on 11/08/2024.
//

import SwiftUI


struct GithubUserDetailView: View {
    
    var userName: String!
    var userAvatarURL: String!
    var userNote: String!
    
    @State var notes = ""
    @State private var showingAlert = false
    @State var title = ""
    @StateObject var viewModel = UserDetailsViewModel()

    @State var userNoteModified: Bool = false
    weak var delegate: GitHubUserDetailsViewControllerDelegate?
    
    func getUserDetails(userName: String) {
        viewModel.getUserDetails(userName: userName)
    }
    
    func getUserAvatar() {
        viewModel.getUserAvatar(withUrl: userAvatarURL)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                if let imageData = viewModel.getUserAvatarData() {
                    Image(uiImage: UIImage(data: imageData)!)
                        .resizable()
                        .frame(height: 200)
                }else {
                    Image("")
                }
                
                HStack(alignment: .center) {
                    Spacer()
                    Text("Followers: \(viewModel.getUserFollowersText())")
                    Spacer()
                    Text("Following: \(viewModel.getUserFollowingText())")
                    Spacer()
                }.padding(.bottom, 24)
                
                Group {
                    VStack(alignment: .leading, content: {
                        HStack {
                            Text("Name: ")
                                .font(.headline)
                            Text("\(viewModel.getUserNameText())")
                                .font(.subheadline)
                        }
                        HStack {
                            Text("Company: ")
                                .font(.headline)
                            Text("\(viewModel.getUserCompanyText())")
                                .font(.subheadline)
                        }
                        HStack {
                            Text("Blog: ")
                                .font(.headline)
                            Text("\(viewModel.getUserBlogText())")
                                .font(.subheadline)
                        }
                    })
                }.padding(.bottom, 24)
                    .padding(.horizontal, 10)
                    
                
                Group {
                    Text("Notes:")
                    TextEditor(text: $notes)
                        .frame(minHeight: 100)
                        .border(.gray, width: 1)
                }.padding(.horizontal, 10)
                
                HStack {
                    Spacer()
                    Button(action: {
                        showingAlert = true
                        userNoteModified = true
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        viewModel.saveUserNote(forUserID: userName, note: notes)
                    }, label: {
                        Text("Save")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                    })
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 0, green: 0, blue: 0.8))
                        .clipShape(Rectangle())
                        .cornerRadius(10)
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Notes saved"), message: Text(""), dismissButton: .default(Text("OK")))
                    }
                    Spacer()
                }
            }.onAppear {
                getUserDetails(userName: userName)
                getUserAvatar()
                notes = userNote
            }
            .onDisappear(perform: {
                if userNoteModified {
                    delegate?.didPopUSerDetailVC(withNote: notes, userName: userName)
                }
            })
            .navigationTitle(userName)
        }
    }
}

#Preview {
    GithubUserDetailView( notes: "")
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
