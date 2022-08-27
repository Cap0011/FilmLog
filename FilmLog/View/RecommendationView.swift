//
//  RecommendationView.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/08/27.
//

import CoreML
import SwiftUI

struct RecommendationView: View {
    @ObservedObject var recommendations = Recommender()
    
    var body: some View {
        VStack {
            Text("This is top 10 recommendations just for you")
        }
        .onAppear {
            recommendations.load()
            print(recommendations.filmIDs)
        }
    }
}

struct RecommendationView_Previews: PreviewProvider {
    static var previews: some View {
        RecommendationView()
    }
}
