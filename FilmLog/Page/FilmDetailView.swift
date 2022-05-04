//
//  FilmDetailView.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/05/04.
//

import SwiftUI

struct FilmDetailView: View {
    
    let filmId: Int
    @ObservedObject private var filmDetailState = FilmDetailState()
    
    var body: some View {
        ZStack {
            Color("Blue").ignoresSafeArea()
            LoadingView(isLoading: self.filmDetailState.isLoading, error: self.filmDetailState.error) {
                self.filmDetailState.loadFilm(id: self.filmId)
            }
            
            if filmDetailState.film != nil {
                FilmDetailListView(film: self.filmDetailState.film!)
            }
        }
        .onAppear {
            self.filmDetailState.loadFilm(id: self.filmId)
        }
    }
}

struct FilmDetailListView: View {
    
    let film: FilmData
    @State private var selectedTrailer: FilmVideo?
    let imageLoader = ImageLoader()
    
    var body: some View {
        List {
            Text("\(film.title) (\(film.yearText))")
                .font(.custom(FontManager.Intro.regular, size: 28))
                .padding(.vertical, 5)
            
            FilmDetailImage(imageURL: self.film.backdropURL)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            
            HStack {
                Text(film.genreText)
                Text("·")
                Text(film.durationText)
            }
            .font(.custom(FontManager.Intro.condBold, size: 20))
            
            Text(film.overview)
                .font(.custom(FontManager.Intro.condLight, size: 18))
                .lineSpacing(3)
            HStack {
                if !film.ratingText.isEmpty {
                    Text(film.ratingText).foregroundColor(.yellow)
                }
                Text(film.scoreText)
            }
            .font(.custom(FontManager.Intro.condBold, size: 20))
            HStack(alignment: .top, spacing: 4) {
                if film.cast != nil && film.cast!.count > 0 {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Starring")
                            .font(.custom(FontManager.Intro.condBold, size: 18))
                        ForEach(self.film.cast!.prefix(9)) { cast in
                            Text(cast.name)
                                .font(.custom(FontManager.Intro.condLight, size: 16))
                        }
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    Spacer()
                    
                }
                
                if film.crew != nil && film.crew!.count > 0 {
                    VStack(alignment: .leading, spacing: 4) {
                        if film.directors != nil && film.directors!.count > 0 {
                            Text("Director(s)")
                                .font(.custom(FontManager.Intro.condBold, size: 18))
                            ForEach(self.film.directors!.prefix(2)) { crew in
                                Text(crew.name)
                                    .font(.custom(FontManager.Intro.condLight, size: 16))
                            }
                        }
                        
                        if film.producers != nil && film.producers!.count > 0 {
                            Text("Producer(s)")
                                .font(.custom(FontManager.Intro.condBold, size: 18))
                                .padding(.top)
                            ForEach(self.film.producers!.prefix(2)) { crew in
                                Text(crew.name)
                                    .font(.custom(FontManager.Intro.condLight, size: 16))
                            }
                        }
                        
                        if film.screenWriters != nil && film.screenWriters!.count > 0 {
                            Text("Screenwriter(s)")
                                .font(.custom(FontManager.Intro.condBold, size: 18))
                                .padding(.top)
                            ForEach(self.film.screenWriters!.prefix(2)) { crew in
                                Text(crew.name)
                                    .font(.custom(FontManager.Intro.condLight, size: 16))
                            }
                        }
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                }
            }
            if film.youtubeTrailers != nil && film.youtubeTrailers!.count > 0 {
                Text("Trailers")
                    .font(.custom(FontManager.Intro.condBold, size: 18))
                
                ForEach(film.youtubeTrailers!) { trailer in
                    Button(action: {
                        self.selectedTrailer = trailer
                    }) {
                        HStack {
                            Text(trailer.name)
                                .font(.custom(FontManager.Intro.condBold, size: 16))
                            Spacer()
                            Image(systemName: "play.circle.fill")
                                .foregroundColor(Color("Blue"))
                        }
                    }
                }
            }
        }
        .sheet(item: self.$selectedTrailer) { trailer in
            SafariView(url: trailer.youtubeURL!)
        }
    }
}

struct FilmDetailImage: View {
    
    @ObservedObject private var imageLoader = ImageLoader()
    let imageURL: URL
    
    var body: some View {
        ZStack {
            Rectangle().fill(.gray.opacity(0.3))
            if self.imageLoader.image != nil {
                Image(uiImage: self.imageLoader.image!)
                    .resizable()
            }
        }
        .aspectRatio(16/9, contentMode: .fit)
        .onAppear {
            self.imageLoader.loadImage(with: self.imageURL)
        }
    }
}

struct FilmDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FilmDetailView(filmId: FilmData.stubbedFilm.id)
        }
    }
}
