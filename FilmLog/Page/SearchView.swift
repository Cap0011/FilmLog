//
//  SearchView.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/05/04.
//

import SwiftUI

struct SearchView: View {
    
    @ObservedObject var filmSearchState: FilmSearchState
    @Binding var isShowingSheet: Bool
    
    var body: some View {
        NavigationView{
            ZStack {
                Color("Blue").ignoresSafeArea()
                List {
                    LoadingView(isLoading: self.filmSearchState.isLoading, error: self.filmSearchState.error) {
                        self.filmSearchState.search(query: self.filmSearchState.query)
                    }
                    
                    if self.filmSearchState.films != nil {
                        ForEach(self.filmSearchState.films!) { film in
                            NavigationLink(destination: FilmDetailView(filmId: film.id)) {
                                VStack(alignment: .leading) {
                                    Text(film.title)
                                    Text(film.yearText)
                                }
                                .font(.custom(FontManager.Intro.condBold, size: 16))
                            }
                        }
                    }
                }
                .onAppear {
                    self.filmSearchState.startObserve()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button(action: {
                self.isShowingSheet = false
            }) {
                Text("Cancel").bold()
            })
        }
    }
}
