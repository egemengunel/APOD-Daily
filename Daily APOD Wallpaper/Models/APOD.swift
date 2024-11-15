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

    static var preview: APOD {
        APOD(
            date: "2024-02-15",
            explanation: "This is a preview explanation of the Astronomy Picture of the Day.",
            hdurl: "https://apod.nasa.gov/apod/image/2402/NGC1566_HubbleOzsarac_2048.jpg",
            media_type: "image",
            title: "Preview APOD Title",
            url: "https://apod.nasa.gov/apod/image/2402/NGC1566_HubbleOzsarac_1024.jpg"
        )
    }
}

