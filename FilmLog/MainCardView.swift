//
//  MainCardView.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/04/28.
//

import SwiftUI

struct MainCardView: View {
    var title = "Tenet"
    var review = "Not time but mind inversion"
    var recommend = true
    var img = "Tenet"
    var body: some View {
        ZStack {
            Image(img)
                .resizable()
                .scaledToFit()
                .frame(width: 175, height: 263)
                .cornerRadius(8)
                .shadow(color: .black.opacity(0.5), radius: 15, x: 0, y: 2)
                .offset(x: 80)
            MainTextView(title: title, review: review, recommend: recommend)
                .offset(x: -80)
        }
        .padding(.vertical, 15)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct MainTextView: View {
    
    @State var isShowingActionSheet = false
    
    var title = "Tenet"
    var review = "Not time but mind inversion"
    var recommend = true
    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                Image(systemName: "ellipsis")
                    .foregroundColor(Color("LightGrey"))
                    .font(.system(size: 20))
                    .frame(width: 30, height: 24)
                    .onTapGesture {
                        isShowingActionSheet = true
                    }
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
        .confirmationDialog(title, isPresented: $isShowingActionSheet, titleVisibility: .visible) {
            Button("Edit", role: .none) {
                //Edit
            }
            Button("Delete", role: .destructive) {
                //Delete
            }
            Button("Cancel", role: .cancel) {
                isShowingActionSheet = false
            }
        }
    }
}

struct MainCardView_Previews: PreviewProvider {
    static var previews: some View {
        MainCardView()
    }
}
