//
//  PListManager.swift
//  Final Project
//
//  Created by Chris Matute on 5/24/24.
//

import Foundation

class PlistManager {
    static let shared = PlistManager()
    private let plistFileName = "SavedPlayers.plist"
    
    private var plistURL: URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(plistFileName)
    }
    
    func savePlayers(_ players: [PlayerData]) {
        guard let plistURL = plistURL else { return }
        do {
            let data = try PropertyListEncoder().encode(players)
            try data.write(to: plistURL)
        } catch {
            print("Error saving players to plist: \(error)")
        }
    }
    
    func loadPlayers() -> [PlayerData]? {
        guard let plistURL = plistURL, let data = try? Data(contentsOf: plistURL) else { return nil }
        do {
            let players = try PropertyListDecoder().decode([PlayerData].self, from: data)
            return players
        } catch {
            print("Error loading players from plist: \(error)")
            return nil
        }
    }
}
