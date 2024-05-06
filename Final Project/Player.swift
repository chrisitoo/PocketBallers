//
//  Football.swift
//  Final Project
//
//  Created by Chris Matute on 4/24/24.
//

import Foundation

struct Player: Codable {
    
    var id: Int
    var firstName: String
    var lastName: String
    var age: Int

    var nationality: String
    var height: String
    var weight: String
    var injured: Bool
    
    struct Birth {
        var date: String
        var place: String
        var country: String
    }
    
}

struct PlayerStats: Codable {
    
    struct Team {
        var teamId: Int
        var name: String
    }

    struct League {
        var leagueId: Int
        var name: String
        var country: String
        var season: Int
    }
    
    struct Games {
        var appearances: Int
        var goals: Int
        var assists: Int
        var position: String
    }
    
}


