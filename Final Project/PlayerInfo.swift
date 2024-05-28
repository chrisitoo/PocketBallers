//
//  Football.swift
//  Final Project
//
//  Created by Chris Matute on 4/24/24.
//

import Foundation

struct Response: Codable {
    let response: [PlayerData]
}

struct PlayerData: Codable {
    let player: Player
    let statistics: [PlayerStats]
    let results: Int?
}

struct Player: Codable {
    let age: Int
    let birth: Birth
    
   
    let firstname: String
    let height: String
    let id: Int
    let injured: Bool
    let lastname: String
    let name: String
    let nationality: String
    let photo: URL
    let weight: String
}

struct Birth: Codable {
    let date: String
    let place: String
    let country: String
}

struct PlayerStats: Codable{
    let cards: Cards
    let dribbles: Dribbles
    let duels: Duels
    let fouls: Fouls
    let games: Games
    let goals: Goals
    let league: League
    let passes: Passes
    let penalty: Penalty
    let shots: Shots
    let substitutes: Substitutes
    let tackles: Tackles
    let team: Team
}

struct Team: Codable {
    let id: Int
    let logo: URL
    let name: String
}

struct League: Codable {
    let id: Int
    let name: String
    let country: String
    let logo: URL
    let flag: URL?
    let season: Int
}

struct Games: Codable {
    let appearances: Int?
    let captain: Bool?
    let lineups: Int?
    let minutes: Int?
    let number: Int?
    let position: String?
    let rating: String?
    
}

struct Substitutes: Codable {
    let bench: Int?
    let `in`: Int?
    let out: Int?
}

struct Shots: Codable {
    let total: Int?
    let on: Int?
}

struct Goals: Codable {
    let total: Int?
    let conceded: Int?
    let assists: Int?
    let saves: Int?
}

struct Passes: Codable {
    let total: Int?
    let key: Int?
    let accuracy: Int?
}

struct Tackles: Codable {
    let blocks: Int?
    let interceptions: Int?
    let total: Int?
}

struct Duels: Codable {
    let total: Int?
    let won: Int?
}

struct Dribbles: Codable {
    let attempts: Int?
    let past: Int?
    let success: Int?
}

struct Fouls: Codable {
    let committed: Int?
    let drawn: Int?
}

struct Cards: Codable {
    let red: Int?
    let yellow: Int?
    let yellowred: Int?
}

struct Penalty: Codable {
    let won: Int?
    let committed: Int?
    let scored: Int?
    let missed: Int?
    let saved: Int?
}


struct PlayerCreds {
    let playerID: Int
    let leagueID: Int
    let season: Int
    let teamID: Int
}

