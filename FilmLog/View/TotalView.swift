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
        UITextView.appearance().backgroundColor = .clear
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.init(name: FontManager.rubikGlitch, size: 12)! ], for: .normal)
    }
    
    var body: some View {
        TabView {
            MainView()
                .tabItem {
                    Image(systemName: "eye")
                    Text("Watched")
                }
            FilmListView()
                .tabItem {
                    Image(systemName: "film")
                    Text("Explore")
                }
            RecommendationView()
                .tabItem {
                    Image(systemName: "rays")
                    Text("For You")
                }
        }
        .preferredColorScheme(.dark)
    }
}

struct TotalView_Previews: PreviewProvider {
    static var previews: some View {
        TotalView()
    }
}
