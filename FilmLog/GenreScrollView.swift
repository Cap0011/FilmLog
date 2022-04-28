//
//  GenreScrollView.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/04/28.
//

import SwiftUI

struct GenreScrollView: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                GenreView(genreTitle: "THRILLER")
                GenreView(genreTitle: "SCI-FI")
                GenreView(genreTitle: "DRAMA")
                GenreView(genreTitle: "ROMANCE")
                GenreView(genreTitle: "HORROR")
            }
        }
    }
}

struct GenreView: View {
    var genreTitle = "Thriller"
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color("LightRed"), lineWidth: 2)
                .frame(width: 70, height: 32)
            Text(genreTitle)
                .font(.custom(FontManager.Intro.condBold, size: 14))
                .foregroundColor(Color("LightRed"))
        }
        .frame(minWidth: 74, minHeight: 36)
    }
}

struct SelectedGenreView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18)
                .frame(width: 70, height: 32)
                .foregroundColor(Color("Red"))
            Text("Sci-Fi")
                .font(.custom(FontManager.Intro.condBold, size: 14))
                .foregroundColor(.white)
                
        }
    }
}

struct GenreScrollView_Previews: PreviewProvider {
    static var previews: some View {
        GenreScrollView()
    }
}
