//
//  MainCardView.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/04/28.
//

import SwiftUI

struct MainCardView: View {
    
    @ObservedObject var film: Film
    
    var body: some View {
        ZStack {
            Image(uiImage: UIImage(data: film.poster!)!)
                .resizable()
                .scaledToFit()
                .frame(width: 175, height: 263)
                .cornerRadius(8)
                .shadow(color: .black.opacity(0.5), radius: 15, x: 0, y: 2)
                .offset(x: 80)
            MainTextView(title: film.title!, review: film.review!, recommend: film.recommend)
                .offset(x: -80)
        }
        .padding(.vertical, 15)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct MainTextView: View {
    
    var title: String
    var review: String
    var recommend: Bool
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                Image(systemName: "ellipsis")
                    .foregroundColor(Color("LightGrey"))
                    .font(.system(size: 20))
                    .frame(width: 30, height: 24)
                Spacer()
                if recommend {
                    Image(systemName: "hand.thumbsup.fill")
                        .foregroundColor(Color("Red"))
                        .font(.system(size: 21))
                        .frame(width: 26, height: 26)
                        .padding(.trailing, 8)
                } else {
                    Image(systemName: "hand.thumbsdown.fill")
                        .foregroundColor(Color("Red"))
                        .font(.system(size: 21))
                        .frame(width: 26, height: 26)
                        .padding(.trailing, 8)
                }
            }
            VStack {
                Spacer()
                VStack (alignment: .leading, spacing: 10) {
                    Text(title)
                        .font(.custom(FontManager.Intro.regular, size: 21))
                        .foregroundColor(Color("Blue"))
                    Text(review)
                        .font(.custom(FontManager.Intro.condLight, size: 16))
                }
                Spacer()
            }
        }
        .padding(8)
        .frame(width: 175, height: 190)
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 2)
    }
}
