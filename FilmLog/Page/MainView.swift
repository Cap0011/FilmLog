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
    
    @State var searchTitle = ""
    @State var isSearching = false
    
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
                        searchBar(searchTitle: $searchTitle, isSearching: $isSearching)
                            .padding(.top, 15)
                            .padding(.bottom, 10)
                        GenreScrollView(selected: $genre, genres: genres)
                            .frame(height: 36)
                            .padding(.horizontal, 20)
                        ScrollView {
                            VStack(spacing: 0) {
                                ForEach(films) { film in
                                    if genre == 0 || film.genre + 1 == genre {
                                        if isSearching == false || searchTitle == "" || film.title!.lowercased().contains(searchTitle.lowercased()) {
                                            MainCardView(film: film)
                                                .confirmationDialog(selectedFilm?.title ?? "", isPresented: $isShowingActionSheet, titleVisibility: .visible) {
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
                                                    selectedFilm = film
                                                    isShowingActionSheet = true
                                                }
                                        }
                                    }
                                }
                            }
                        }
                        .simultaneousGesture(DragGesture().onChanged({ gesture in
                            withAnimation{
                                UIApplication.shared.dismissKeyboard()
                            }
                        }))
                    }
                .toolbar {
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

struct searchBar: View {
    
    @Binding var searchTitle: String
    @Binding var isSearching: Bool
    
    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: isSearching ? 2 : 1)
                    .frame(height: 40)
                HStack {
                    Image(systemName: "magnifyingglass")
                        .padding(.leading, 10)
                    ZStack(alignment: .leading) {
                        if searchTitle.isEmpty  {
                            Text("Search film title")
                                .font(.custom(FontManager.Intro.condLight, size: 16))
                        }
                        TextField("", text: $searchTitle) { startedEditing in
                            if startedEditing {
                                withAnimation {
                                    isSearching = true
                                }
                            }
                        } onCommit: {
                            withAnimation {
                                isSearching = false
                            }
                        }
                            .font(.custom(FontManager.Intro.regular, size: 16))
                    }
                    .padding(.leading, 10)
                }
            }
            if isSearching {
                Button {
                    searchTitle = ""
                    withAnimation {
                        isSearching = false
                        UIApplication.shared.dismissKeyboard()
                    }
                } label: {
                    Text("Cancel")
                        .font(.custom(FontManager.Intro.condLight, size: 16))
                }
            }
        }
        .foregroundColor(isSearching ? .white : .white.opacity(0.6))
        .padding(.horizontal, 20)
    }
}

extension UIApplication {
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
