//
//  HomeViewController.swift
//  Final Project
//
//  Created by Chris Matute on 4/24/24.
//

import UIKit
import Foundation


class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var playerResponse: Response?
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let url = URL(string:"https://v3.football.api-sports.io/players/topscorers?league=140&season=2023")!
        var request = URLRequest(url: url)
        request.addValue("4fc176f9aa1841a75a883276b9a18aee", forHTTPHeaderField: "x-apisports-key")
        request.httpMethod = "GET"
        
        
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) {(data, response, error) in
            if let error = error {
                print("Failure: \(error.localizedDescription)")
            } else {
                if let data = data, let topScorers = self.parse(data:data) {
                    self.playerResponse = topScorers
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
            
            
        }
        dataTask.resume()
        
    }
    
    func parse(data:Data) -> Response? {
        do {
            let decoder = JSONDecoder()
            let topScorers = try decoder.decode(Response.self, from: data)
            return topScorers
        } catch {
            print("JSON error: \(error)")
            return nil
        }
    }
    
    enum FootyError: Error {
        case invalidURL
        case invalidResponse
        case invalidData
    }
    
    // TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerResponse?.response.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeItem" , for: indexPath)
       
        var cellContent = cell.defaultContentConfiguration()
    
        cellContent.text = playerResponse?.response[indexPath.row].player.name
        cell.contentConfiguration = cellContent
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
