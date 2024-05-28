//
//  PlayerOverviewVC.swift
//  Final Project
//
//  Created by Chris Matute on 5/17/24.
//

import UIKit

class PlayerOverviewVC: UIViewController {
    
    
    @IBOutlet weak var playerPicture: UIImageView!
    @IBOutlet weak var playerName: UILabel!
    
    @IBOutlet weak var playerGoals: UILabel!
    @IBOutlet weak var playerAssists: UILabel!
    @IBOutlet weak var playerTeam: UILabel!
    @IBOutlet weak var playerNationality: UILabel!
    
    @IBOutlet weak var playerFlag: UIImageView!
    
    var selectedPlayer: Response?
    
    var playerID: Int = 0
    var leagueID: Int = 0
    var season: Int = 0
    var teamID: Int = 0
    
    
    var downloadTask: URLSessionDownloadTask?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = ""
        
        
        fetchPlayerDetails(playerID: playerID, leagueID: leagueID, season: season, teamID: teamID)
        
        
    }
    
    
    func fetchPlayerDetails (playerID: Int, leagueID: Int, season: Int, teamID: Int) {
        let url = URL(string:"https://v3.football.api-sports.io/players?id=\(playerID)&league=\(leagueID)&season=\(season)&team=\(teamID)")!
        var request = URLRequest(url: url)
        request.addValue("4fc176f9aa1841a75a883276b9a18aee", forHTTPHeaderField: "x-apisports-key")
        request.httpMethod = "GET"
        
        
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) {(data, response, error) in
            if let error = error {
                print("Failure: \(error.localizedDescription)")
            } else {
                if let data = data, let player = self.parse(data:data) {
                    self.selectedPlayer = player
                    
                    DispatchQueue.main.async { [self] in
                        updateOverview(selectedPlayer: selectedPlayer)
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

    func updateOverview(selectedPlayer: Response?) {
        
        guard let player = selectedPlayer?.response[0] else {return}
    
        playerName.text = "\(player.player.firstname) \(player.player.lastname)"
        
        let url = player.player.photo
        
        downloadTask = playerPicture.loadImage(url: url)
        
        let playerNation = player.statistics[0].team.logo
           
        downloadTask = playerFlag.loadImage(url: playerNation)
        
        
        appendTextLabel()
        
        
        
    }
    
    func appendTextLabel() {
        guard let player = selectedPlayer?.response[0].statistics[0] else {return}
        
        if let goals = player.goals.total {
            playerGoals.text = "Goals: \(goals)"
        }
        
        if let assists = player.goals.assists {
            playerAssists.text = "Assists: \(assists)"
        }
        
        playerTeam.text = "Team: \(player.team.name)"
        
        playerNationality.text = "Nationality: \(player.league.country)"
        
        playerName.textAlignment = .center
        
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
