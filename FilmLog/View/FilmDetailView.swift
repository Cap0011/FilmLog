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
            ScrollView {
                LoadingView(isLoading: self.filmDetailState.isLoading, error: self.filmDetailState.error) {
                    self.filmDetailState.loadFilm(id: self.filmId)
                }
                
                if filmDetailState.film != nil {
                    FilmDetailListView(film: self.filmDetailState.film!)
                }
            }
            .ignoresSafeArea()
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
        ZStack(alignment: .topLeading) {
            Color("Blue").ignoresSafeArea()
            VStack(alignment: .leading) {
                ZStack(alignment: .bottomTrailing) {
                    FilmDetailImage(imageURL: self.film.backdropURL)
                    FilmRatingCircle(value: film.voteAverage * 10)
                        .offset(x: -16, y: -16)
                }
                HStack {
                    FilmPosterImage(imageURL: self.film.posterURL)
                        .shadow(radius: 4)
                        .offset(y: -50)
                        .padding(.bottom, -50)
                        .padding(.leading, 16)
                        .padding(.trailing, 8)
                    VStack(alignment: .leading, spacing: 8) {
                        Text(film.title)
                            .font(.custom(FontManager.Inconsolata.black, size: 22))
                        Text("\(film.genreText)· \(film.durationText) · \(film.yearText)")
                            .font(.custom(FontManager.Inconsolata.regular, size: 16))
                        HStack(spacing: 8) {
                            Image(systemName: "plus.circle.fill")
                                .onTapGesture {
                                    // TODO: Leave a review
                                }
                            Image(systemName: "bookmark.circle.fill")
                                .onTapGesture {
                                    // TODO: Add to watch list
                                }
                        }
                        .font(.system(size: 30))
                        .foregroundColor(Color("Red"))
                    }
                    .padding(.trailing, 8)
                    .foregroundColor(.white)
                }
                
                VStack(alignment: .leading) {
                    Text("Overview")
                        .font(.custom(FontManager.Inconsolata.black, size: 18))
                        .foregroundColor(Color("Red"))
                        .padding(.bottom, 8)
                    Text(film.overview)
                        .padding(.bottom, 16)
                    
                    Text("Director")
                        .font(.custom(FontManager.Inconsolata.black, size: 18))
                        .foregroundColor(Color("Red"))
                        .padding(.bottom, 8)
                    Text(film.directorText)
                        .padding(.bottom, 16)
                    
                    Text("Cast")
                        .font(.custom(FontManager.Inconsolata.black, size: 18))
                        .foregroundColor(Color("Red"))
                        .padding(.bottom, 8)
                    Text(film.castText)
                        .padding(.bottom, 16)
                    
                    Text("Videos")
                        .font(.custom(FontManager.Inconsolata.black, size: 18))
                        .foregroundColor(Color("Red"))
                        .padding(.bottom, 8)
                }
                .frame(maxHeight: .infinity)
                .padding(.top, 24)
                .padding(.horizontal, 16)
                .lineSpacing(8)
                .minimumScaleFactor(1)
                .font(.custom(FontManager.Inconsolata.regular, size: 16))
                .multilineTextAlignment(.leading)
                .foregroundColor(.white)
                
                if film.videos != nil && film.videos!.results.count > 0 {
                    YoutubeCarouselView(videos: film.videos!.results)
                }
            }
            .ignoresSafeArea()
            .padding(.bottom, 100)
        }
    }
}

struct FilmDetailImage: View {
    @ObservedObject private var imageLoader = ImageLoader()
    let imageURL: URL
    
    var body: some View {
        ZStack {
            Image("NoPosterBackdrop")
                .resizable()
            if self.imageLoader.image != nil {
                Image(uiImage: self.imageLoader.image!)
                    .resizable()
            }
        }
        .aspectRatio(270/152, contentMode: .fit)
        .frame(width: UIScreen.main.bounds.size.width)
        .onAppear {
            self.imageLoader.loadImage(with: self.imageURL)
        }
    }
}

struct FilmPosterImage: View {
    @ObservedObject private var imageLoader = ImageLoader()
    let imageURL: URL
    
    var body: some View {
        ZStack {
            Image("NoPoster")
                .resizable()
            if self.imageLoader.image != nil {
                Image(uiImage: self.imageLoader.image!)
                    .resizable()
            }
        }
        .aspectRatio(2/3, contentMode: .fit)
        .frame(width: 120)
        .cornerRadius(4)
        .onAppear {
            self.imageLoader.loadImage(with: self.imageURL)
        }
    }
}

struct FilmRatingCircle: View {
    let value: Double
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(Color("Blue"))
                .frame(width: 46, height: 46)
            
            Circle()
                .stroke(lineWidth: 3)
                .foregroundColor(Color("Red"))
                .opacity(0.3)
                .frame(width: 41, height: 41)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(value * 0.01))
                .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color("Red"))
                .frame(width: 41, height: 41)
                .rotationEffect(.degrees(-90))
            
            Text("\(Int(value))%")
                .font(.custom(FontManager.Inconsolata.black, size: 20))
                .foregroundColor(.white)
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
