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
        if film.poster != nil {
            VStack {
                let img = Image(uiImage: UIImage(data: film.poster!)!)
                img
                    .resizable()
                    .aspectRatio(168/248 ,contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.size.width / 2 - 24)
                    .cornerRadius(8)
                MainTextView(title: film.title!, review: film.review!, recommend: film.recommend)
                    .offset(y: -40)
            }
            .padding(.bottom, -40)
        }
    }
}

struct MainTextView: View {
    
    var title: String
    var review: String
    var recommend: Bool
    
    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 18)
                .frame(width: 36, height: 36)
                .foregroundColor(.white)
                .offset(y: -18)
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.custom(FontManager.rubikGlitch, size: 20))
                    .multilineTextAlignment(.center)
                Text(review)
                    .font(.custom(FontManager.Inconsolata.regular, size: 16))
                    .multilineTextAlignment(.center)
            }
            .foregroundColor(.black)
            .padding(.bottom, 16)
            .padding(.top, 8)
            .padding(.horizontal, 8)
            
            if recommend {
                Image(systemName: "heart.fill")
                    .foregroundColor(Color("Red"))
                    .font(.system(size: 20))
                    .offset(y: -12)
            } else {
                Image(systemName: "heart.slash")
                    .foregroundColor(Color("Red"))
                    .font(.system(size: 20))
                    .offset(y: -12)
            }
        }
        .frame(width: UIScreen.main.bounds.size.width / 2 - 24)
        .background(RoundedRectangle(cornerRadius: 8).foregroundColor(.white))
    }
}
