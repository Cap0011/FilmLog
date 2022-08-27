//
//  AddFilmView.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/04/28.
//

import SwiftUI
import AlertToast

struct AddFilmView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var isShowingSheet: Bool
    @State private var showErrorToast = false
    
    @State private var imagePickerPresented = false
    @State private var selectedImage: UIImage?
    @State private var selectedURL: URL?
    @ObservedObject var imageLoader = ImageLoader()
    @State private var isShowingActionSheet: Bool = false
    @State private var isShowingSearchSheet: Bool = false
    
    @State private var filmImage: Image?
    @State private var genre: Int = 1
    @State private var title: String = ""
    @State private var review: String = ""
    @State private var recommend: Bool = true
    @State private var id: String = ""
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                Color("Blue").ignoresSafeArea()
                VStack {
                    let image = filmImage ?? Image("White")
                    image
                        .resizable()
                        .aspectRatio(168/248 ,contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.size.width / 2 - 24)
                        .cornerRadius(8)
                        .shadow(color: .black.opacity(0.1), radius: 15, x: 0, y: 2)
                        .padding(.vertical, 16)
                        .confirmationDialog("How would you like to pick the film poster?", isPresented: $isShowingActionSheet, titleVisibility: .visible) {
                            Button("Choose from gallery", role: .none) {
                                // Open ImagePicker
                                self.imageLoader.image = nil
                                self.selectedURL = nil
                                imagePickerPresented.toggle()
                            }
                            Button("Look up", role: .none) {
                                // Look up film from tmdb
                                isShowingSearchSheet.toggle()
                            }
                            Button("Cancel", role: .cancel) {
                                isShowingActionSheet = false
                            }
                        }
                        .onTapGesture {
                            isShowingActionSheet.toggle()
                        }
                        .sheet(isPresented: $imagePickerPresented,
                               onDismiss: loadImage,
                               content: { ImagePicker(image: $selectedImage) })
                        .sheet(isPresented: $isShowingSearchSheet,
                               onDismiss: loadImage) {
                            ImageSearchView(imageLoader: imageLoader, isShowingSheet: $isShowingSearchSheet, selectedURL: $selectedURL, title: $title, id: $id)
                        }
                    
                    GenreScrollView(selected: $genre, isAllIncluded: false)
                        .padding(.bottom, 16)
                    
                    TextField("Film title", text: $title)
                        .padding(.leading, 16)
                        .foregroundColor(.white)
                        .frame(height: 40)
                        .font(.custom(FontManager.rubikGlitch, size: 17))
                        .background(RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 1).foregroundColor(.white))
                        .padding(.horizontal, 16)
                        .padding(.bottom, 8)
                    
                    ZStack(alignment: .topLeading) {
                        if review.isEmpty {
                            Text("How did you find the film?")
                                .padding(.horizontal, 32)
                                .padding(.top, 8)
                                .foregroundColor(.white)
                                .opacity(0.4)
                        }
                        
                        TextEditor(text: $review)
                            .padding(.horizontal, 12)
                            .frame(height: 80)
                            .lineSpacing(4)
                            .background(RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 1).foregroundColor(.white))
                            .padding(.horizontal, 16)
                    }
                    .font(.custom(FontManager.Inconsolata.regular, size: 17))
   
                    VStack(spacing: 24) {
                        Text("Would you watch it again?")
                            .font(.custom(FontManager.Inconsolata.black, size: 22))
                            .foregroundColor(.white)
                        
                        HStack(spacing: 80) {
                            VStack(spacing: 5) {
                                Image(systemName: "heart.fill")
                                    .font(.system(size: 40))
                                Text("For sure")
                                    .font(.custom(FontManager.Inconsolata.regular, size: 17))
                            }
                            .foregroundColor(recommend ? Color("Red") : .white)
                            .onTapGesture {
                                recommend = true
                            }
                            
                            VStack(spacing: 5) {
                                Image(systemName: "heart.slash")
                                    .font(.system(size: 40))
                                Text("I'm good")
                                    .font(.custom(FontManager.Inconsolata.regular, size: 17))
                            }
                            .foregroundColor(recommend ? .white : Color("Red"))
                            .onTapGesture {
                                recommend = false
                            }
                        }
                    }
                    .padding(.top, 24)
                }
            }
            .toast(isPresenting: $showErrorToast, alert: {
                AlertToast(displayMode: .banner(.pop), type: .error(Color("Red")), title: "Please fill in all the required fields.")
            })
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        self.isShowingSheet.toggle()
                    } label: {
                        Text("Cancel")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // If incomplete -> toast
                        if filmImage == nil || title == "" {
                            showErrorToast.toggle()
                        }
                        // If complete -> save
                        else {
                            self.isShowingSheet = false
                            addFilm(title: title, review: review, genre: genre, recommend: recommend, poster: selectedImage!)
                        }
                    } label: {
                        Text("Save").bold()
                    }
                }
            }
        }
    }
    
    private func loadImage() {
        if self.selectedURL != nil {
            Task {
                await self.imageLoader.loadImageforPoster(with: selectedURL!)
                selectedImage = self.imageLoader.image ?? UIImage(named: "NoPoster")
                filmImage = Image(uiImage: selectedImage!)
            }
        } else {
            guard let selectedImage = selectedImage else { return }
            filmImage = Image(uiImage: selectedImage)
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
    
    private func addFilm(title: String, review: String, genre: Int, recommend: Bool, poster: UIImage) {
        let newFilm = Film(context: viewContext)
        newFilm.title = title
        newFilm.recommend = recommend
        newFilm.review = review
        newFilm.genre = Int64(genre)
        newFilm.poster = poster.pngData()
        newFilm.id = id
        
        saveContext()
    }
    
}
