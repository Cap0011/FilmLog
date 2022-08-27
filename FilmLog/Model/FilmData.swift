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
    
    var backdropURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(backdropPath ?? "")")!
    }
    
    var posterURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath ?? "")")!
    }
    
    var genreText: String {
        var text = ""
        if genres?.count ?? 0 < 3 {
            genres?.forEach { genre in
                text = text + "\(genre.name) "
            }
        } else {
            text = "\(genres![0].name) \(genres![1].name) \(genres![2].name) "
        }
        
        return text
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
        
        return "\(runtime / 60)h \(runtime % 60)m"
    }
    
    var directorText: String {
        if self.directors != nil && self.directors!.count > 0 {
            var text = ""
            self.directors!.forEach { director in
                text = "\(text)\(director.name) · "
            }
            return String(text.dropLast(3))
        } else {
            return "n/a"
        }
    }
    
    var castText: String {
        if self.cast != nil && self.cast!.count > 0 {
            var text = ""
            self.cast!.prefix(10).forEach { cast in
                text = "\(text)\(cast.name) · "
            }
            return String(text.dropLast(3))
        } else {
            return "n/a"
        }
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
    
    var youtubeThumbnailURL: URL? {
        return URL(string: "https://img.youtube.com/vi/\(key)/0.jpg")
    }
}
