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
            VStack(alignment: .leading, spacing: 0) {
                Text(title)
                    .font(.custom(FontManager.Intro.regular, size: 21))
                    .padding(.horizontal)
                    .padding(.top, 30)
                    .foregroundColor(Color("Red"))
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 18) {
                        ForEach(self.films) { film in
                            NavigationLink(destination: FilmDetailView(filmId: film.id)) {
                                FilmBackdropCard(film: film)
                                    .frame(width: 272, height: 200)
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

struct FilmBackdropCarouselView_Previews: PreviewProvider {
    static var previews: some View {
        FilmBackdropCarouselView(title: "Latest", films: FilmData.stubbedFilms)
    }
}
