//
//  FilmSearchRow.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/08/16.
//

import SwiftUI

struct FilmSearchRow: View {
    var film: FilmData
    @ObservedObject var loader = ImageLoader()
    
    var body: some View {
        VStack {
            HStack(spacing: 24) {
                ZStack {
                    Image(uiImage: (self.loader.image ?? UIImage(named: "NoPoster"))!)
                        .resizable()
                }
                .aspectRatio(168/248 ,contentMode: .fit)
                .frame(width: 80)
                .cornerRadius(4)
                VStack(alignment: .leading, spacing: 8) {
                    Text(film.title)
                        .font(.custom(FontManager.rubikGlitch, size: 20))
                    Text(film.yearText)
                        .font(.custom(FontManager.Inconsolata.regular, size: 16))
                }
                .multilineTextAlignment(.leading)
                .foregroundColor(.white)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .onAppear {
                loader.loadImage(with: film.posterURL)
            }
            
            Rectangle()
                .frame(height: 0.3)
                .foregroundColor(Color("LightGrey"))
                .padding(.horizontal, 16)
        }
    }
}

