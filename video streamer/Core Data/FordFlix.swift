//
//  Flix.swift
//  ugggh
//
//  Created by Connor Woodford on 5/21/18.
//  Copyright © 2018 Connor Woodford. All rights reserved.
//

import Foundation

struct Courses: Codable {
    var location: String?
    var resolution: String?
    var backdropPhotoUrl: String?
    var title: String?
    var id: Int?
    var browser: String?
    var fileformat: String?
    var fileName: String?
    var adult: Bool?
    var channels: Double?
    var backdrop_path: String?
    var original_language: String?
    var original_title: String?
    var overview: String?
    var popularity: Double?
    var poster_path: String?
    var release_date: String?
    var vote_average: Double?
    var vote_count: Double?
    var filePath: String?
    var photoUrl: String?
    var json: [String: Any] {
        return [
        "location": location,
        "resolution": resolution,
        "backdropPhotoUrl": backdropPhotoUrl,
        "title": title,
        "id": id,
        "fileName": fileName,
        "browser": "Safari",
        "fileformat": ".m3u8",
        "adult": adult,
        "channels": channels,
        "backdrop_path": backdrop_path,
        "original_language": original_language,
        "original_title": original_title,
        "overview": overview,
        "popularity": popularity,
        "poster_path": poster_path,
        "release_date": release_date,
        "vote_average": vote_average,
        "vote_count": vote_count,
        "filePath": filePath,
        "photoUrl": photoUrl
        ]
    }
}

