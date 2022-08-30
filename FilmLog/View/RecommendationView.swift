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
    
    @ObservedObject private var recommendationsState = FilmListState()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("Blue").ignoresSafeArea()
                VStack(spacing: 16) {
                    Text("Films you might love")
                        .foregroundColor(Color("Red"))
                        .font(.system(size: 24, weight: .black))
                        .padding(.top, 56)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 4)
                    
                    if recommendationsState.films != nil && recommendationsState.films!.count == 10 {
                        RecommendationPostersView(films: recommendationsState.films!)
                    } else {
                        LoadingView(isLoading: recommendationsState.isLoading, error: recommendationsState.error) {
                            recommendationsState.loadFilms(with: recommendations.filmIDs)
                        }
                    }
                }
                .ignoresSafeArea()
            }
            .ignoresSafeArea()
//            .toolbar {
//                ToolbarItem(placement: .principal) {
//                    Text("Filog")
//                        .font(.custom(FontManager.rubikGlitch, size: 20))
//                        .foregroundColor(.white)
//                        .accessibilityAddTraits(.isHeader)
//                }
//            }
        }
        .navigationBarHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            recommendations.load()
            recommendationsState.loadFilms(with: recommendations.filmIDs)
        }
    }
}

struct RecommendationView_Previews: PreviewProvider {
    static var previews: some View {
        RecommendationView()
    }
}
