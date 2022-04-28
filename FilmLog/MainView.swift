//
//  MainView.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/04/27.
//

import SwiftUI

struct MainView: View {
    
    @State var isShowingSheet = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("Blue").ignoresSafeArea()
                    VStack {
                        GenreScrollView()
                        .frame(height: 36)
                        .padding(.horizontal, 26)
                        .padding(.top, 20)
                        ScrollView {
                            VStack(spacing: 0) {
                                MainCardView(title: "Tenet", review: "Not time but mind inversion", recommend: true, img: "Tenet")
                                MainCardView(title: "The Amazing Spiderman 2", review: "Too many villains", recommend: false, img: "Spiderman")
                                MainCardView(title: "tick, tick...BOOM!", review: "BOOM!", recommend: true, img: "Tick")
                            }
                        }
                    }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            //Search
                        } label: {
                            Label("Search", systemImage: "magnifyingglass")
                                .foregroundColor(.white)
                        }
                    }
                    ToolbarItem(placement: .principal) {
                        Text("FILMLOG")
                            .font(.custom(FontManager.Intro.regular, size: 21))
                            .foregroundColor(.white)
                            .accessibilityAddTraits(.isHeader)
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            //Add
                            isShowingSheet.toggle()
                        } label: {
                            Label("Add", systemImage: "plus")
                                .foregroundColor(.white)
                        }
                    }
                }
                .sheet(isPresented: $isShowingSheet) {
                    AddFilmView(isShowingSheet: self.$isShowingSheet)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
