//
//  MainView.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/04/27.
//

import SwiftUI

struct MainView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.title)
    ])
    
    private var films: FetchedResults<Film>
    @State private var selectedFilm: FetchedResults<Film>.Element?
    
    @State private var isShowingSheet = false
    @State private var isShowingEditSheet = false
    @State private var isShowingActionSheet = false
    
    @State private var genre = 0
    
    @State var refresh: Bool = false
    
    let genres: [String] = [
        "All",
        "Thriller",
        "Sci-fi",
        "Action",
        "Drama",
        "Comedy",
        "Horror",
        "Romance",
        "Musical",
        "Fantasy",
        "History"
    ]
    
    var body: some View {
        
        NavigationView {
            ZStack {
                Color("Blue").ignoresSafeArea()
                    VStack {
                        GenreScrollView(selected: $genre, genres: genres)
                        .frame(height: 36)
                        .padding(.horizontal, 26)
                        .padding(.top, 20)
                        ScrollView {
                            VStack(spacing: 0) {
                                ForEach(films) { film in
                                    if genre == 0 || film.genre + 1 == genre {
                                        MainCardView(film: film)
                                            .confirmationDialog("Edit or Delete", isPresented: $isShowingActionSheet) {
                                                Button("Edit", role: .none) {
                                                    //Open Edit Sheet
                                                    isShowingEditSheet.toggle()
                                                }
                                                Button("Delete", role: .destructive) {
                                                    //Delete
                                                    deleteFilm(object: selectedFilm!)
                                                }
                                                Button("Cancel", role: .cancel) {
                                                    isShowingActionSheet = false
                                                }
                                            }
                                            .onTapGesture {
                                                isShowingActionSheet = true
                                                selectedFilm = film
                                            }
                                            
                                    }
                                }
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
                .sheet(isPresented: $isShowingEditSheet) {
                    EditFilmView(isShowingSheet: self.$isShowingEditSheet, film: $selectedFilm)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("Unresolved Error: \(error)")
        }
    }
    
    private func deleteFilm(object: Film) {
        viewContext.delete(object)
        saveContext()
    }
}
