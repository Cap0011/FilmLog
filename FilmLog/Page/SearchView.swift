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
                        }
                    }
                }
            }
            .onAppear {
                self.filmSearchState.startObserve()
            }
            .navigationBarTitle("Search")
        }
    }
}
