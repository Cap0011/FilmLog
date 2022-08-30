//
//  Recommender.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/08/28.
//

import CoreML
import SwiftUI

class Recommender: ObservableObject {
    @Published var filmIDs = [String]()

    init() {
        loadLinks()
        load()
    }
    
    private func loadLinks() {
        do {
            let filePath = Bundle.main.path(forResource: "links", ofType: "csv")
            let content = try String(contentsOfFile: filePath ?? "")
            let parsedCSV: [String] = content.components(
                separatedBy: "\n"
            )
            
            let MLIDs: [String] = parsedCSV.map{ $0.components(separatedBy: ",").first! }
            let TMDBIDs: [String] = parsedCSV.map{ String($0.components(separatedBy: ",").last!.dropLast(1)) }
            
            for i in 0..<MLIDs.count {
                Constants.shared.MLtoTMDB[String(MLIDs[i])] = TMDBIDs[i]
                Constants.shared.TMDBtoML[String(TMDBIDs[i])] = MLIDs[i]
           }
        }
        catch(let error) {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    private func userRatings() -> [Int64: Double] {
        var ratings: [Int64: Double] = [:]
        Constants.shared.films.forEach { film in
            if film.recommend && Constants.shared.TMDBtoML[film.id!] != nil {
                ratings[Int64(Constants.shared.TMDBtoML[film.id!]!)!] = 5.0
            }
        }
        return ratings
    }
    
    func load() {
        do{
            let config = MLModelConfiguration()
            let model = try MyMovieRecommender(configuration: config)
            let input = MyMovieRecommenderInput(items: userRatings(), k: 10, restrict_: [], exclude: [])

            let result = try model.prediction(input: input)
            var tempFilms = [String]()

            for id in result.recommendations {
                if Constants.shared.MLtoTMDB[String(id)] != nil {
                    tempFilms.append(Constants.shared.MLtoTMDB[String(id)]!)
                }
            }
            filmIDs = tempFilms
        } catch(let error) {
            print("Error: \(error.localizedDescription)")
        }
    }
}
