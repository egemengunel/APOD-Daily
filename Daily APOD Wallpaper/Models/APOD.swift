//
//  APOD.swift
//  Daily APOD Wallpaper
//
//  Created by Egemen Günel on 22/11/2023.
//

import Foundation

struct APOD: Codable, Identifiable, Equatable {
    var id: String { date }
    let date: String
    let explanation: String
    let hdurl: String
    let media_type: String
    let title: String
    let url: String
    var isFavorite: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case date, explanation, hdurl, media_type, title, url
    }
}

