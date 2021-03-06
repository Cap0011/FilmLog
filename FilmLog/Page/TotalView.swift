//
//  TotalView.swift
//  FilmLog
//
//  Created by Jiyoung Park on 2022/05/04.
//

import SwiftUI

struct TotalView: View {
    
    init() {
        UITabBar.appearance().barTintColor = UIColor(Color("Blue"))
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.init(name: FontManager.Intro.condBold, size: 12)! ], for: .normal)
    }
    
    var body: some View {
        TabView {
            MainView()
                .tabItem {
                    Image(systemName: "film.fill")
                    Text("Watched")
                        .font(.custom(FontManager.Intro.regular, size: 18))
                }
            FilmListView()
                .tabItem {
                    Image(systemName: "list.and.film")
                    Text("Explore")
                }
        }
    }
}

struct TotalView_Previews: PreviewProvider {
    static var previews: some View {
        TotalView()
    }
}
