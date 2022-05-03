//
//  FilmPosterCarouselView.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/05/03.
//

import SwiftUI

struct FilmPosterCarouselView: View {
    
    let title: String
    let films: [FilmData]
    
    var body: some View {
        ZStack {
            Color("Blue").ignoresSafeArea()
            VStack(alignment: .leading, spacing: 16) {
                Text(title)
                    .font(.custom(FontManager.Intro.regular, size: 21))
                    .padding(.horizontal)
                    .foregroundColor(Color("Red"))
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 18) {
                        ForEach(self.films) { film in
                            NavigationLink(destination: FilmDetailView(filmId: film.id)) {
                                FilmPosterCard(film: film)
                                    .padding(.trailing, film.id == self.films.last!.id ? 16 : 0)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
            }
        }
        
    }
}

struct FilmPosterCarouselView_Previews: PreviewProvider {
    static var previews: some View {
        FilmPosterCarouselView(title: "Now Playing", films: FilmData.stubbedFilms)
    }
}
