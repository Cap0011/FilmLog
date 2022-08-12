//
//  GenreScrollView.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/04/28.
//

import SwiftUI

struct GenreScrollView: View {
    
    @Binding var selected: Int
        
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(Genres.allCases.indices) { idx in
                    if idx != selected {
                        // Unselected
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color("LightRed"), lineWidth: 1)
                                .frame(width: 68, height: 30)
                            Text(Genres.allCases[idx].rawValue)
                                .font(.custom(FontManager.rubikGlitch, size: 14))
                                .foregroundColor(Color("LightRed"))
                        }
                        .onTapGesture {
                            selected = idx
                        }
                    } else {
                        // Selected
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .frame(width: 70, height: 32)
                                .foregroundColor(Color("Red"))
                            Text(Genres.allCases[idx].rawValue)
                                .font(.custom(FontManager.rubikGlitch, size: 14))
                                .foregroundColor(.white)
                        }
                        .onTapGesture {
                            selected = 0
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}
