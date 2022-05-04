//
//  ImageSearchView.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/05/04.
//

import SwiftUI

struct ImageSearchView: View {
    
    @ObservedObject var filmSearchState = FilmSearchState()
    @ObservedObject var imageLoader: ImageLoader
    @Binding var isShowingSheet: Bool
    @Binding var selectedURL: URL?
    @Binding var title: String
    @State private var isSearching = false
    
    var body: some View {
        NavigationView{
            ZStack {
                Color("Blue").ignoresSafeArea()
                VStack {
                    searchBar(searchTitle: $filmSearchState.query, isSearching: $isSearching)
                        .padding(.top, 15)
                    List {
                        LoadingView(isLoading: self.filmSearchState.isLoading, error: self.filmSearchState.error) {
                            self.filmSearchState.search(query: self.filmSearchState.query)
                        }
                        
                        if self.filmSearchState.films != nil {
                            ForEach(self.filmSearchState.films!) { film in
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text(film.title)
                                        Spacer()
                                    }
                                    HStack {
                                        Text(film.yearText)
                                        Spacer()
                                    }
                                }
                                .onTapGesture {
                                    //Pass posterURL and film title, close this sheet
                                    selectedURL = film.posterURL
                                    title = film.title
                                    imageLoader.image = nil
                                    self.isShowingSheet = false
                                }
                                .font(.custom(FontManager.Intro.condBold, size: 16))
                            }
                        }
                    }
                    .onAppear {
                        self.filmSearchState.startObserve()
                    }
                    .onDisappear {
                        
                    }
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
