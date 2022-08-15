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
        ZStack {
            if self.imageLoader.image != nil {
                Image(uiImage: self.imageLoader.image!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(8)
                    .shadow(radius: 4)
            } else {
                Rectangle()
                    .fill(.gray.opacity(0.3))
                    .cornerRadius(8)
                    .shadow(radius: 4)
                
                Text(film.title)
                    .multilineTextAlignment(.center)
                    .font(.custom(FontManager.Intro.condBold, size: 16))
            }
        }
        .padding(.bottom, 10)
        .frame(width: 204, height: 306)
        .onAppear {
            Task {
                await self.imageLoader.loadImage(with: self.film.posterURL)
            }
        }
    }
}

struct FilmPosterCard_Previews: PreviewProvider {
    static var previews: some View {
        FilmPosterCard(film: FilmData.stubbedFilm)
    }
}
