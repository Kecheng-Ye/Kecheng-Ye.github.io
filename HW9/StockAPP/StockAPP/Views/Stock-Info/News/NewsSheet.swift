//
//  NewsSheet.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/16/22.
//

import SwiftUI

struct NewsSheet: View {
    let singleNews: SingleNews
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                dissmissBtn
                title
                Divider()
                content
                Spacer()
            }
        }
        .fullWidth()
        .padding()
    }
    
    var dissmissBtn: some View {
        Button(action: closesheet) {
            Image(systemName: "multiply")
                .fullWidth(alignment: .trailing)
                .padding(.vertical, 10)
                .foregroundColor(.black)
        }
    }
    
    
    var title: some View {
        VStack(alignment: .leading) {
            Text(singleNews.source).font(.largeTitle).fontWeight(.bold)
            Text(singleNews.date).foregroundColor(.gray)
        }
    }
    
    var content: some View {
        VStack(alignment: .leading) {
            Text(singleNews.headline).fontWeight(.bold).font(.title2)
            Text(singleNews.summary).font(.subheadline)
            link.font(.subheadline)
            icons
        }
    }
    
    var link: some View {
        HStack(spacing: 3) {
            Text("For more details click").foregroundColor(.gray)
            Link(destination: singleNews.url!) {
                Text("here").foregroundColor(.blue)
            }
        }
    }
    
    var icons: some View {
        HStack {
            twitterIcon
            facebookIcon
        }
    }
    
    var twitterIcon: some View {
        Link(destination: singleNews.twitterShareURL()) {
            Image("Twitter social icons - circle - blue")
                .resizable()
                .frame(maxWidth: 50, maxHeight: 50)
        }
            
    }
    
    var facebookIcon: some View {
        Link(destination: singleNews.facebookShareURL()) {
            Image("f_logo_RGB-Blue_144")
                .resizable()
                .frame(maxWidth: 50, maxHeight: 50)
        }
    }
}

struct NewsSheet_Previews: PreviewProvider {
    static var previews: some View {
        NewsSheet(singleNews: SingleNews.example2())
    }
}
