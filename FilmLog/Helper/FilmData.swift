//
//  FilmData.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/05/03.
//

import Foundation

struct FilmResponse: Decodable {
    let results: [FilmData]
}

struct FilmData : Decodable, Identifiable {
    let id: Int
    let title: String
    let backdropPath: String?
    let posterPath: String?
    let overview: String
    let voteAverage: Double
    let voteCount: Int
    let runtime: Int?
    let releaseDate: String?
    
    let genres: [FilmGenre]?
    let credits: FilmCredit?
    let videos: FilmVideoResponse?
    
    static private let yearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }()
    
    static private let durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.hour, .minute]
        return formatter
    }()
    
    var backdropURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(backdropPath ?? "")")!
    }
    
    var posterURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath ?? "")")!
    }
    
    var genreText: String {
        genres?.first?.name ?? "n/a"
    }
    
    var ratingText: String {
        let rating = Int(voteAverage)
        let ratingText = (0..<rating).reduce("") { (acc, _) -> String in
            return acc + "⭐️"
        }
        return ratingText
    }
    
    var scoreText: String {
        guard ratingText.count > 0 else {
            return "n/a"
        }
        return "\(ratingText.count)/10"
    }
    
    var yearText: String {
        guard let releaseDate = self.releaseDate, let date = Utils.dateFormatter.date(from: releaseDate) else {
            return "n/a"
        }
        return FilmData.yearFormatter.string(from: date)
    }
    
    var durationText: String {
        guard let runtime = self.runtime, runtime > 0 else {
            return "n/a"
        }
        
        return FilmData.durationFormatter.string(from: TimeInterval(runtime) * 60) ?? "n/a"
    }
    
    var cast: [FilmCast]? {
        credits?.cast
    }
    
    var crew: [FilmCrew]? {
        credits?.crew
    }
    
    var directors: [FilmCrew]? {
        crew?.filter { $0.job.lowercased() == "director" }
    }
    
    var producers: [FilmCrew]? {
        crew?.filter { $0.job.lowercased() == "producer" }
    }
    
    var screenWriters: [FilmCrew]? {
        crew?.filter { $0.job.lowercased() == "story" }
    }
    
    var youtubeTrailers: [FilmVideo]? {
        videos?.results.filter { $0.youtubeURL != nil }
    }
}

struct FilmGenre: Decodable {
    let name: String
}

struct FilmCredit: Decodable {
    
    let cast: [FilmCast]
    let crew: [FilmCrew]
}

struct FilmCast: Decodable, Identifiable {
    let id: Int
    let character: String
    let name: String
}

struct FilmCrew: Decodable, Identifiable {
    let id: Int
    let job: String
    let name: String
}

struct FilmVideoResponse: Decodable {
    
    let results: [FilmVideo]
}

struct FilmVideo: Decodable, Identifiable {
    
    let id: String
    let key: String
    let name: String
    let site: String
    
    var youtubeURL: URL? {
        guard site == "YouTube" else {
            return nil
        }
        return URL(string: "https://youtube.com/watch?v=\(key)")
    }
}
