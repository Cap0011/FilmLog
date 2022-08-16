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
            ZStack(alignment: .top) {
                Color("Blue").ignoresSafeArea()
                VStack {
                    SearchBar(searchTitle: $filmSearchState.query, isSearching: $isSearching)
                    
                    ScrollView {
                        LoadingView(isLoading: self.filmSearchState.isLoading, error: self.filmSearchState.error) {
                            self.filmSearchState.search(query: self.filmSearchState.query)
                        }
                        
                        if self.filmSearchState.films != nil {
                            ForEach(self.filmSearchState.films!) { film in
                                FilmSearchRow(film: film)
                                    .listRowBackground(Color.clear)
                                .onTapGesture {
                                    // Pass posterURL and film title, close this sheet
                                    selectedURL = film.posterURL
                                    title = film.title
                                    imageLoader.image = nil
                                    self.isShowingSheet = false
                                }
                            }
                        }
                    }
                }
                .onAppear {
                    self.filmSearchState.startObserve()
                }
                .onDisappear {
                    
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button(action: {
                self.isShowingSheet = false
            }) {
                Text("Cancel")
            })
        }
    }
}

struct FilmSearchRow: View {
    var film: FilmData
    @ObservedObject var loader = ImageLoader()
    
    var body: some View {
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
