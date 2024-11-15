//
//  NetworkService.swift
//  Daily APOD Wallpaper
//
//  Created by Egemen Günel on 15/11/2024.
//

import Foundation

class NetworkService {
    static let shared = NetworkService()
    private let apiKey = ProcessInfo.processInfo.environment["API_KEY"] ?? ""
    
    func fetchAPOD() async throws -> APOD {
        let urlString = "https://api.nasa.gov/planetary/apod?api_key=\(apiKey)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        return try decoder.decode(APOD.self, from: data)
    }
}
