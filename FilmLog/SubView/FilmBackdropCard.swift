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
            ZStack {
                Rectangle()
                    .fill(.gray.opacity(0.3))
                
                if self.imageLoader.image != nil {
                    Image(uiImage: self.imageLoader.image!)
                        .resizable()
                }
            }
            .aspectRatio(16/9, contentMode: .fit)
            .cornerRadius(8)
            .shadow(radius: 4)
            
            Text(film.title)
                .font(.custom(FontManager.Intro.condBold, size: 16))
        }
        .lineLimit(1)
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
