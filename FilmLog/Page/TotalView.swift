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
    }
    
    var body: some View {
        TabView {
            MainView()
                .tabItem {
                    Image(systemName: "film.fill")
                        .tint(Color("Red"))
                }
            FilmListView()
                .tabItem {
                    Image(systemName: "list.and.film")
                        .tint(Color("Red"))
                }
        }
    }
}

struct TotalView_Previews: PreviewProvider {
    static var previews: some View {
        TotalView()
    }
}
