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
    
    @State private var isShowingSheet = false
    @State private var isShowingEditSheet = false
    @State private var isShowingActionSheet = false
    
    @State private var genre: Int?
    
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
                                ForEach(films) { film in
                                    MainCardView(film: film)
                                        .onTapGesture {
                                            isShowingActionSheet = true
                                        }
                                        .confirmationDialog(film.title!, isPresented: $isShowingActionSheet, titleVisibility: .visible) {
                                            Button("Edit", role: .none) {
                                                //Open Edit Sheet
                                                isShowingEditSheet.toggle()
                                    
                                            }
                                            Button("Delete", role: .destructive) {
                                                //Delete
                                                //deleteFilm(offsets: films.indices)
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
    
    private func deleteFilm(offsets: IndexSet) {
        offsets.map { films[$0] }.forEach(viewContext.delete)
        saveContext()
    }
    
    private func updateFilm(_ film: FetchedResults<Film>.Element) {
        film.title! += " Done!"
        saveContext()
    }
}
