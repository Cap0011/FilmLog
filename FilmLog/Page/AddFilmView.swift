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
    @State private var genre: Int = 0
    @State private var title: String = ""
    @State private var review: String = ""
    @State private var recommend: Bool = true
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("LightBlue").ignoresSafeArea()
                VStack {
                    ZStack {
                        let image = filmImage ?? Image("White")
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 178, height: 266)
                            .cornerRadius(8)
                            .shadow(color: .black.opacity(0.1), radius: 15, x: 0, y: 2)
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(Color("Red"))
                    }
                    .padding(.bottom, 15)
                    .confirmationDialog("How would you like to pick the film poster?", isPresented: $isShowingActionSheet, titleVisibility: .visible) {
                        Button("Choose from gallery", role: .none) {
                            //Open ImagePicker
                            self.imageLoader.image = nil
                            self.selectedURL = nil
                            imagePickerPresented.toggle()
                        }
                        Button("Look up", role: .none) {
                            //Search Film
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
                        ImageSearchView(imageLoader: imageLoader, isShowingSheet: $isShowingSearchSheet, selectedURL: $selectedURL, title: $title)
                    }
                    
                    GenreScrollView(selected: $genre)
                        .padding(.horizontal, 26)
                        .padding(.bottom, 15)
                    
                    TextField(
                            "FILM TITLE",
                            text: $title
                        )
                    .preferredColorScheme(.light)
                    .frame(width: 318, height: 40)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding([.horizontal], 10)
                    .font(.custom(FontManager.Intro.regular, size: 16))
                    .background(RoundedRectangle(cornerRadius: 8).foregroundColor(.white).frame(width: 338, height: 40).shadow(color: .black.opacity(0.1), radius: 15, x: 0, y: 2))

                    TextField(
                            "How did you find the film?",
                            text: $review
                        )
                    .preferredColorScheme(.light)
                    .frame(width: 318, height: 80)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding([.horizontal], 10)
                    .font(.custom(FontManager.Intro.condLight, size: 16))
                    .background(RoundedRectangle(cornerRadius: 8).foregroundColor(.white).frame(width: 338, height: 80).shadow(color: .black.opacity(0.1), radius: 15, x: 0, y: 2))
                    .padding(.vertical, 10)

                    HStack(spacing: 50) {
                        Image(systemName: "hand.thumbsup.circle")
                            .foregroundColor(recommend ? Color("Red") : Color("LightGrey"))
                            .font(.system(size: 60))
                            .onTapGesture {
                                recommend = true
                            }
                        Image(systemName: "hand.thumbsdown.circle")
                            .foregroundColor(recommend ? Color("LightGrey") : Color("Red"))
                            .font(.system(size: 60))
                            .onTapGesture {
                                recommend = false
                            }
                    }
                    .padding(.bottom, 40)

                    Button(action: {
                        //if incomplete -> toast
                        if filmImage == nil || title == "" {
                            showErrorToast.toggle()
                        }
                        //if complete -> save
                        else {
                            self.isShowingSheet = false
                            addFilm(title: title, review: review, genre: genre, recommend: recommend, poster: selectedImage!)
                        }
                        }) {
                            Text("SAVE")
                                .frame(width: 338, height: 50)
                                .font(.custom(FontManager.Intro.regular, size: 18))
                                .foregroundColor(.white)
                                .background(RoundedRectangle(cornerRadius: 25).foregroundColor(Color("Red")))
                    }
                        .shadow(color: .black.opacity(0.22), radius: 15, x: 0, y: 2)
                }
            }
            .toast(isPresenting: $showErrorToast, alert: {
                AlertToast(displayMode: .banner(.pop), type: .error(Color("Red")), title: "Please fill in all the required fields.")
            })
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button(action: {
                self.isShowingSheet = false
            }) {
                Text("Cancel").bold()
            })
        }

    }
    
    private func loadImage() {
        if self.selectedURL != nil {
            self.imageLoader.loadImage(with: selectedURL!)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if self.imageLoader.image != nil {
                    selectedImage = self.imageLoader.image
                    filmImage = Image(uiImage: selectedImage!)
                } else {
                    loadImage()
                }
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
        
        saveContext()
    }
    
}
