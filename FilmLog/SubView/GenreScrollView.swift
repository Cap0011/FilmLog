//
//  GenreScrollView.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/04/28.
//

import SwiftUI

struct GenreScrollView: View {
    
    @Binding var selected: Int
    
    var genres: [String]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(genres.indices) { i in
                    if i != selected {
                        //unselected
                        ZStack {
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(Color("LightRed"), lineWidth: 2)
                                .frame(width: 70, height: 32)
                            Text(genres[i])
                                .font(.custom(FontManager.Intro.condBold, size: 14))
                                .foregroundColor(Color("LightRed"))
                        }
                        .frame(minWidth: 74, minHeight: 36)
                        .onTapGesture {
                            selected = i
                        }
                    } else {
                        //selected
                        ZStack {
                            RoundedRectangle(cornerRadius: 18)
                                .frame(width: 74, height: 36)
                                .foregroundColor(Color("Red"))
                            Text(genres[i])
                                .font(.custom(FontManager.Intro.condBold, size: 14))
                                .foregroundColor(.white)
                                
                        }
                        .onTapGesture {
                            selected = 0
                        }
                    }
                }
            }
        }
    }
}
