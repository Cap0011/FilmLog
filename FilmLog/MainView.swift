//
//  MainView.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/04/27.
//

import SwiftUI

struct MainView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [])
    
    private var films: FetchedResults<Film>
    @State private var selectedFilm: FetchedResults<Film>.Element?
    
    @State private var isShowingSheet = false
    @State private var isShowingEditSheet = false
    @State private var isShowingActionSheet = false
    
    @State private var genre: Int?
    @State private var idx = 0
    
    var body: some View {
        
        NavigationView {
            ZStack {
                Color("Blue").ignoresSafeArea()
                    VStack {
                        GenreScrollView(selected: $genre)
                        .frame(height: 36)
                        .padding(.horizontal, 26)
                        .padding(.top, 20)
                        ScrollView {
                            VStack(spacing: 0) {
                                ForEach(self.films.indices, id: \.self) { index in
                                    MainCardView(film: films[index])
                                        .onTapGesture {
                                            isShowingActionSheet = true
                                            idx = index
                                        }
                                        .confirmationDialog(films[idx].title!, isPresented: $isShowingActionSheet, titleVisibility: .visible) {
                                            Button("Edit", role: .none) {
                                                //Open Edit Sheet
                                                isShowingEditSheet.toggle()
                                                selectedFilm = films[idx]
                                            }
                                            Button("Delete", role: .destructive) {
                                                //Delete
                                                deleteFilm(object: films[idx])
                                            }
                                            Button("Cancel", role: .cancel) {
                                                isShowingActionSheet = false
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
                    EditFilmView(isShowingSheet: self.$isShowingEditSheet, film: $selectedFilm, idx: idx)
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
    
    private func deleteFilm(object: FetchedResults<Film>.Element) {
        idx = 0
        viewContext.delete(object)
        saveContext()
    }
    
    private func updateFilm(_ film: FetchedResults<Film>.Element) {
        film.title! += " Done!"
        saveContext()
    }
}
