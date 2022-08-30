//
//  RecommendationPostersView.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/08/30.
//

import SwiftUI
import CachedAsyncImage

struct RecommendationPostersView: View {
    @State var films: [FilmData]
    
    var body: some View {
        VStack {
            NavigationLink(destination: FilmDetailView(filmId: films.first!.id)) {
                RecommendationPosterView(film: films.first!, width: UIScreen.main.bounds.size.width / 2, rank: 1, color: Color("Red"), fontSize: 20)
                    .padding(.bottom, 16)
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(1..<films.count) { idx in
                        NavigationLink(destination: FilmDetailView(filmId: films[idx].id)) {
                            RecommendationPosterView(film: films[idx], width: (UIScreen.main.bounds.size.width - 32) / 2.5, rank: idx + 1, color: Color("Blue"), fontSize: 18)
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
}

struct RecommendationPosterView: View {
    let film: FilmData
    let width: CGFloat
    let rank: Int?
    let color: Color
    let fontSize: CGFloat
    
    var body: some View {
        VStack {
            ZStack(alignment: .topLeading) {
                CachedAsyncImage(url: film.posterURL)  { image in
                    image
                        .resizable()
                } placeholder: {
                    Image("NoPoster")
                        .resizable()
                }
                .aspectRatio(168/248, contentMode: .fit)
                .cornerRadius(8)
                .shadow(radius: 4)
                .frame(width: width)
                
                if rank != nil {
                    ZStack {
                        Capsule()
                            .frame(width: 60, height: 30, alignment: .center)
                            .foregroundColor(color)
                            .opacity(0.7)
                        Text(rankText(rank: rank!))
                            .font(.custom(FontManager.rubikGlitch, size: fontSize))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 8)
                }
            }
            Text(film.title)
                .lineLimit(1)
                .frame(width: width)
                .font(.system(size: 16, weight: .black))
                .foregroundColor(.white)
        }
    }
    
    private func rankText(rank: Int) -> String {
        switch(rank % 10) {
        case 1: return "\(rank)st"
        case 2: return "\(rank)nd"
        case 3: return "\(rank)rd"
        default: return "\(rank)th"
        }
    }
}
