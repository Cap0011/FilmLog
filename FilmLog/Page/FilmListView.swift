//
//  FilmListView.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/05/03.
//

import SwiftUI

struct FilmListView: View {
    
    @ObservedObject private var nowPlayingState = FilmListState()
    @ObservedObject private var upcomingState = FilmListState()
    @ObservedObject private var topRatedState = FilmListState()
    @ObservedObject private var popularState = FilmListState()
    
    @State var isSearching = false
    @State var isShowingSearchView = false
    @ObservedObject var filmSearchState = FilmSearchState()
    
    init(){
        UITableView.appearance().backgroundColor = .clear
        UITableView.appearance().separatorStyle = .none
        UINavigationBar.appearance().titleTextAttributes = [.font: UIFont(name: FontManager.Intro.regular, size: 20)!]
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("Blue").ignoresSafeArea()
                VStack {
                    searchBar(searchTitle: $filmSearchState.query, isSearching: $isSearching)
                        .padding(.top, 15)
                        .onSubmit {
                            isShowingSearchView.toggle()
                        }
                    List {
                        Group {
                            if nowPlayingState.films != nil {
                                FilmPosterCarouselView(title: "Now Playing", films: nowPlayingState.films!)
                            } else {
                                LoadingView(isLoading: nowPlayingState.isLoading, error: nowPlayingState.error) {
                                    self.nowPlayingState.loadFilms(with: .nowPlaying)
                                }
                            }
                        }
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                        Group {
                            if upcomingState.films != nil {
                                FilmBackdropCarouselView(title: "Upcoming", films: upcomingState.films!)
                            } else {
                                LoadingView(isLoading: upcomingState.isLoading, error: upcomingState.error) {
                                    self.upcomingState.loadFilms(with: .upcoming)
                                }
                            }
                        }
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                        Group {
                            if topRatedState.films != nil {
                                FilmBackdropCarouselView(title: "Top rated", films: topRatedState.films!)
                            } else {
                                LoadingView(isLoading: topRatedState.isLoading, error: topRatedState.error) {
                                    self.topRatedState.loadFilms(with: .topRated)
                                }
                            }
                        }
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                        Group {
                            if popularState.films != nil {
                                FilmBackdropCarouselView(title: "Popular", films: popularState.films!)
                            } else {
                                LoadingView(isLoading: popularState.isLoading, error: popularState.error) {
                                    self.popularState.loadFilms(with: .popular)
                                }
                            }
                        }
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    }
                    .foregroundColor(.white)
                }
            }
            .sheet(isPresented: $isShowingSearchView) {
                SearchView(filmSearchState: filmSearchState, isShowingSheet: self.$isShowingSearchView)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("FILMLOG")
                        .font(.custom(FontManager.Intro.regular, size: 21))
                        .foregroundColor(.white)
                        .accessibilityAddTraits(.isHeader)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            self.nowPlayingState.loadFilms(with: .nowPlaying)
            self.upcomingState.loadFilms(with: .upcoming)
            self.topRatedState.loadFilms(with: .topRated)
            self.popularState.loadFilms(with: .popular)
        }
        
    }
}

struct FilmListView_Previews: PreviewProvider {
    static var previews: some View {
        FilmListView()
    }
}
