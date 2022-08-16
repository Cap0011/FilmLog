//
//  FilmBackdropCard.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/05/03.
//

import SwiftUI

struct FilmBackdropCard: View {
    
    let film: FilmData
    @ObservedObject var imageLoader = ImageLoader()
    
    var body: some View {
        VStack(alignment: .leading) {
            if self.imageLoader.image != nil {
                Image(uiImage: self.imageLoader.image!)
                    .resizable()
                    .aspectRatio(270/152, contentMode: .fit)
                    .cornerRadius(8)
                    .shadow(radius: 4)
            } else {
                Image("NoPosterBackdrop")
                    .resizable()
                    .aspectRatio(270/152, contentMode: .fit)
                    .cornerRadius(8)
                    .shadow(radius: 4)
            }
            Text(film.title)
                .multilineTextAlignment(.leading)
                .font(.custom(FontManager.Inconsolata.black, size: 18))
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .truncationMode(.tail)
                .lineLimit(1)
        }
        .frame(width: 270)
        .onAppear {
            self.imageLoader.loadImage(with: self.film.backdropURL)
        }
    }
}

struct FilmBackdropCard_Previews: PreviewProvider {
    static var previews: some View {
        FilmBackdropCard(film: FilmData.stubbedFilm)
    }
}
