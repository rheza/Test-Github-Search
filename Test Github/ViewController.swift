//
//  ViewController.swift
//  Test Github
//
//  Created by Rheza Pahlevi on 11/15/20.
//  Copyright © 2020 Rheza Pahlevi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var orderingButton: UIButton!
    @IBOutlet weak var searchText: UITextField!
    
    
    var userData = [Item]()
    var ascending = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.orderingButton.setTitle("ASC", for: .normal)
        searchText.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func orderButtonAction(_ sender: Any) {
        if !ascending {
            self.ascending = true
            
            self.orderingButton.setTitle("DESC", for: .normal)
            self.userData = self.userData.sorted(by: { $0.login > $1.login })
        } else {
            self.ascending = false
            self.orderingButton.setTitle("ASC", for: .normal)
            self.userData = self.userData.sorted(by: { $1.login > $0.login })
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func getUserList(searchText: String)
    {
        let url = URL(string: "https://www.google.com/search?q=peace")!
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            
            if error != nil || data == nil {
                print("Client error!")
                return
            }
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error!")
                return
            }
            print("The Response is : ",response)
        }
        task.resume()
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        NSObject.cancelPreviousPerformRequests(
            withTarget: self,
            selector: #selector(ViewController.searchUser),
            object: textField)
        self.perform(
            #selector(ViewController.searchUser),
            with: textField,
            afterDelay: 0.5)
        return true
    }
    
    @objc func searchUser(textField: UITextField) {
       
        DispatchQueue.main.async {
            self.userData.removeAll()
            self.tableView.reloadData()

        }
        let searchQuery = textField.text ?? ""
        let url = URL(string: "https://api.github.com/search/users?q=\(searchQuery)&page=1")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField:"Accept")
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            if error != nil || data == nil {
                print("Client error!")
                return
            }
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error!")
                return
            }
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do {
                   let decoder = JSONDecoder()
                   let usersData = try decoder.decode(GithubUsers.self, from: dataResponse)
                   print(usersData.totalCount)
                    
                    DispatchQueue.main.async {
                        self.userData = usersData.items
                        self.tableView.reloadData()

                    }

                    
               } catch let err {
                   print("Err", err)
            }
            
        }
        task.resume()
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let userCell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
        
        userCell.usernameLabel.text = userData[indexPath.row].login
        userCell.userAvatar.image = UIImage(named: "Default")
        DispatchQueue.main.async {
            userCell.userAvatar.image = UIImage(url: URL(string: self.userData[indexPath.row].avatarURL))
        }
        
        return userCell
    }
}

extension UIImage {
  convenience init?(url: URL?) {
    guard let url = url else { return nil }
            
    do {
      self.init(data: try Data(contentsOf: url))
    } catch {
      print("Cannot load image from url: \(url) with error: \(error)")
      return nil
    }
  }
}
