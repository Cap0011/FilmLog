//
//  AddFilmView.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/04/28.
//

import SwiftUI
import AlertToast

struct AddFilmView: View {
    
    @Binding var isShowingSheet: Bool
    @State private var showErrorToast = false
    
    @State private var imagePickerPresented = false
    @State private var selectedImage: UIImage?
    
    @State private var filmImage: Image?
    @State private var genre: Int?
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
                            .scaledToFit()
                            .frame(width: 178, height: 266)
                            .cornerRadius(8)
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(Color("Red"))
                    }
                    .padding(.bottom, 15)
                    .onTapGesture {
                        imagePickerPresented.toggle()
                    }
                    .sheet(isPresented: $imagePickerPresented,
                           onDismiss: loadImage,
                           content: { ImagePicker(image: $selectedImage) })
                    
                    GenreScrollView(selected: $genre)
                        .padding(.horizontal, 26)
                        .padding(.bottom, 15)
                    
                    TextField(
                            "FILM TITLE",
                            text: $title
                        )
                    .frame(width: 318, height: 40)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding([.horizontal], 10)
                    .font(.custom(FontManager.Intro.regular, size: 16))
                    .background(RoundedRectangle(cornerRadius: 8).foregroundColor(.white).frame(width: 338, height: 40))

                    TextField(
                            "How did you find the film?",
                            text: $review
                        )
                    .frame(width: 318, height: 80)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding([.horizontal], 10)
                    .font(.custom(FontManager.Intro.condLight, size: 16))
                    .background(RoundedRectangle(cornerRadius: 8).foregroundColor(.white).frame(width: 338, height: 80))
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
                        if filmImage == nil || genre == nil || title == "" {
                            showErrorToast.toggle()
                        }
                        //if complete -> save
                        else {
                            self.isShowingSheet = false
                        }
                        }) {
                            Text("SAVE")
                                .frame(width: 338, height: 50)
                                .font(.custom(FontManager.Intro.regular, size: 18))
                                .foregroundColor(.white)
                                .background(RoundedRectangle(cornerRadius: 25).foregroundColor(Color("Red")))
                    }
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
        guard let selectedImage = selectedImage else { return }
        filmImage = Image(uiImage: selectedImage)
    }
}
