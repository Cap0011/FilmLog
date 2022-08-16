//
//  FilmBackdropCarouselView.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/05/03.
//

import SwiftUI

struct FilmBackdropCarouselView: View {
    
    let title: String
    let films: [FilmData]
    
    var body: some View {
        ZStack {
            Color("Blue").ignoresSafeArea()
            VStack(alignment: .leading, spacing: 16) {
                Text(title)
                    .font(.custom(FontManager.rubikGlitch, size: 20))
                    .padding(.leading, 24)
                    .foregroundColor(.white)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(self.films) { film in
                            NavigationLink(destination: FilmDetailView(filmId: film.id)) {
                                FilmBackdropCard(film: film)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
        .padding(.bottom, 24)
    }
}

struct FilmBackdropCarouselView_Previews: PreviewProvider {
    static var previews: some View {
        FilmBackdropCarouselView(title: "Latest", films: FilmData.stubbedFilms)
    }
}
