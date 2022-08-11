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
                VStack(spacing: 16) {
                        searchBar(searchTitle: $searchTitle, isSearching: $isSearching)
                        GenreScrollView(selected: $genre, genres: genres)
                            .frame(height: 36)
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
                        Text("FilmLog")
                            .font(.custom(FontManager.rubikGlitch, size: 20))
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
                    .stroke(lineWidth: 1)
                    .frame(height: 32)
                HStack(spacing: 16) {
                    Image(systemName: "magnifyingglass")
                        .padding(.leading, 8)
                    ZStack(alignment: .leading) {
                        if searchTitle.isEmpty  {
                            Text("Film title")
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
                    }
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
                }
            }
        }
        .font(.custom(FontManager.rubikGlitch, size: 16))
        .foregroundColor(isSearching ? .white : .white.opacity(0.6))
        .padding(.horizontal, 16)
    }
}

extension UIApplication {
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
