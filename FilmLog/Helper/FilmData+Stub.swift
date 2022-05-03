//
//  FilmData+Stub.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/05/03.
//

import Foundation

extension FilmData {
    static var stubbedFilms: [FilmData] {
        let response: FilmResponse? = try? Bundle.main.loadAndDecodeJSON(filename: "film_list")
        return response!.results
    }
    
    static var stubbedFilm: FilmData {
        stubbedFilms[0]
    }
}

extension Bundle {
    func loadAndDecodeJSON<D: Decodable>(filename: String) throws -> D? {
        guard let url = self.url(forResource: filename, withExtension: "json") else {
            return nil
        }
        let data = try Data(contentsOf: url)
        let jsonDecoder = Utils.jsonDecoder
        let decodedModel = try jsonDecoder.decode(D.self, from: data)
        return decodedModel
    }
}
