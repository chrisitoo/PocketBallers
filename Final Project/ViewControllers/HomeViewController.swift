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
    var downloadTask: URLSessionDownloadTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchTopScorers()
    
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
       
        let nib = UINib(nibName: "PlayerTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "PlayerTableViewCell")
        
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
    
    
    }
    
    
    
    func fetchTopScorers() {
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
    
    func fetchTopAssisters() {
        let url = URL(string:"https://v3.football.api-sports.io/players/topassists?league=39&season=2023")!
        var request = URLRequest(url: url)
        request.addValue("4fc176f9aa1841a75a883276b9a18aee", forHTTPHeaderField: "x-apisports-key")
        request.httpMethod = "GET"
        
        
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) {(data, response, error) in
            if let error = error {
                print("Failure: \(error.localizedDescription)")
            } else {
                if let data = data, let topAssisters = self.parse(data:data) {
                    
                    DispatchQueue.main.async {
                       
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
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PlayerTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "PlayerTableViewCell" , for: indexPath) as? PlayerTableViewCell)!
        
            if let player = playerResponse?.response[indexPath.row].player {
                cell.playerNameLabel.text = "\(indexPath.row + 1). \(player.firstname) \(player.lastname)"
                
                let selectedFootballer = playerResponse?.response[indexPath.row]
                
                let url = playerResponse?.response[indexPath.row].player.photo
                
                downloadTask = cell.playerImageView.loadImage(url: url!)

        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PlayerOverviewVC,
           let playerData  = sender as? PlayerCreds {
            destination.playerID = playerData.playerID
            destination.leagueID = playerData.leagueID
            destination.season = playerData.season
            destination.teamID = playerData.teamID
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let selectedFootballer = playerResponse?.response[indexPath.row] {
            
            let playerID = selectedFootballer.player.id
            let teamID = selectedFootballer.statistics[0].team.id
            let leagueID = selectedFootballer.statistics[0].league.id
            let season = selectedFootballer.statistics[0].league.season
            
            let playerCreds = PlayerCreds(playerID: playerID, leagueID: leagueID, season: season, teamID: teamID)
            
            
            performSegue(withIdentifier: "toPlayerOverview", sender: playerCreds)
            
        }
    }
        
        
    }

