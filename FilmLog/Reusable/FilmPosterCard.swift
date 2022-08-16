//
//  FilmPosterCard.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/05/03.
//

import SwiftUI

struct FilmPosterCard: View {
    
    let film: FilmData
    @ObservedObject var imageLoader = ImageLoader()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if self.imageLoader.image != nil {
                Image(uiImage: self.imageLoader.image!)
                    .resizable()
                    .aspectRatio(168/248, contentMode: .fit)
                    .cornerRadius(8)
                    .shadow(radius: 4)
            } else {
                Image("NoPoster")
                    .resizable()
                    .aspectRatio(168/248, contentMode: .fit)
                    .cornerRadius(8)
                    .shadow(radius: 4)
                
                Text(film.title)
                    .multilineTextAlignment(.leading)
                    .font(.custom(FontManager.Inconsolata.black, size: 18))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.bottom, 8)
                    .truncationMode(.tail)
                    .lineLimit(1)
            }
        }
        .frame(width: 200)
        .onAppear {
            self.imageLoader.loadImage(with: self.film.posterURL)
        }
    }
}

struct FilmPosterCard_Previews: PreviewProvider {
    static var previews: some View {
        FilmPosterCard(film: FilmData.stubbedFilm)
    }
}
