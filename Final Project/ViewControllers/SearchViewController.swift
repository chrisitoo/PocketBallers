//
//  SearchViewController.swift
//  Final Project
//
//  Created by Chris Matute on 5/1/24.
//

import UIKit


class SearchViewController: UIViewController, UISearchBarDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var selectedPlayer: Response?
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var downloadTask: URLSessionDownloadTask?
    
    var searchHistory: [Response?] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        numberTextField.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
        let nib = UINib(nibName: "PlayerTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "PlayerTableViewCell")
        tableView.reloadData()
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.text = searchText
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            fetchPlayerDetails(searchText: searchBar.text ?? "")
            return true
        }
    
    
    func fetchPlayerDetails(searchText: String) {
        print(searchText)
       
        guard let numberText = numberTextField.text, !numberText.isEmpty else {
            print("Number input is required")
                    return
        }
        
        let url = URL(string:"https://v3.football.api-sports.io/players?search=\(searchText)&season=2024&team=\(numberText)")!
        var request = URLRequest(url: url)
        request.addValue("4fc176f9aa1841a75a883276b9a18aee", forHTTPHeaderField: "x-apisports-key")
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) {(data, response, error) in
            if let error = error {
                print("Failure: \(error.localizedDescription)")
                DispatchQueue.main.sync {
                    self.showAlert(title: "Error", message: "Network error: \(error.localizedDescription)")
                }
            } else {
                if let data = data, let player = self.parse(data:data), !player.response.isEmpty {
                    self.selectedPlayer = player
                    self.sendPlayerCreds()
                    self.saveToSearchHistory(player: player)
                    
                } else {
                    print("No player data found")
                    DispatchQueue.main.async {
                        self.showAlert(title: "Error", message: "No player data found")
                    }
                    
                }
                
            }
            
            
        }
        
        dataTask.resume()
    }
    
    
    func parse(data:Data) -> Response? {
        do {
            let decoder = JSONDecoder()
            let player = try decoder.decode(Response.self, from: data)
            return player
        } catch {
            print("JSON error: \(error)")
            return nil
        }
    }
    
    func saveToSearchHistory(player: Response) {
            searchHistory.append(player)
            print(searchHistory.count)
            DispatchQueue.main.async {
                self.tableView.reloadData()
        }
    }
    
    // TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerTableViewCell", for: indexPath) as! PlayerTableViewCell
        
        if let player = searchHistory[indexPath.row]?.response[0] {
            cell.playerNameLabel.text = "\(player.player.firstname) \(player.player.lastname)"
           
            let url = player.player.photo
            downloadTask = cell.playerImageView.loadImage(url: url)
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedPlayer = searchHistory[indexPath.row] {
            if let selectedFootballer = selectedPlayer.response.first {
                   let playerID = selectedFootballer.player.id
                   let teamID = selectedFootballer.statistics[0].team.id
                   let leagueID = selectedFootballer.statistics[0].league.id
                   let season = selectedFootballer.statistics[0].league.season
                   
                   let playerCreds = PlayerCreds(playerID: playerID, leagueID: leagueID, season: season, teamID: teamID)
                   
                   performSegue(withIdentifier: "fromSearchToOverview", sender: playerCreds)
               }
           }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Navigation
    
    
    func sendPlayerCreds() {
        DispatchQueue.main.async {
            if let selectedFootballer = self.selectedPlayer?.response[0] {
                
                let playerID = selectedFootballer.player.id
                let teamID = selectedFootballer.statistics[0].team.id
                let leagueID = selectedFootballer.statistics[0].league.id
                let season = selectedFootballer.statistics[0].league.season
                
                let playerCreds = PlayerCreds(playerID: playerID, leagueID: leagueID, season: season, teamID: teamID)
                
                self.performSegue(withIdentifier: "fromSearchToOverview", sender: playerCreds)
        }
    }
}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PlayerOverviewVC,
               let playerData  = sender as? PlayerCreds {
                destination.playerID = playerData.playerID
                destination.leagueID = playerData.leagueID
                destination.season = playerData.season
                destination.teamID = playerData.teamID
            }
            
    }
    
    
}
