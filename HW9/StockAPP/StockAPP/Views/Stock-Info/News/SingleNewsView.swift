//
//  SingleNewsView.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/16/22.
//

import SwiftUI

struct headNews: View {
    @State private var showingSheet = false
    let singleNews: SingleNews
    
    var body: some View {
        VStack {
            image
            title
        }
        .onTapGesture {
            showingSheet = true
        }
        .sheet(isPresented: $showingSheet) {
            NewsSheet(singleNews: singleNews)
        }
    }
    
    var image: some View {
        AsyncImage(
            url: singleNews.image,
            content: { image in
                image
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: 500)
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
            },
            placeholder: {
                ProgressView()
            }
        )
    }
    
    var title: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(singleNews.source).fontWeight(.semibold)
                Text(singleNews.calculateTimeDiff())
            }
            .foregroundColor(.gray).font(.caption)
            Text(singleNews.headline).fontWeight(.bold)
        }.frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct normalSingleNews: View {
    @State private var showingSheet = false
    let singleNews: SingleNews
    
    var body: some View {
        HStack() {
            title.frame(maxWidth: 250, alignment: .leading)
            Spacer()
            image
        }
        .onTapGesture {
            showingSheet = true
        }
        .sheet(isPresented: $showingSheet) {
            NewsSheet(singleNews: singleNews)
        }
    }
    
    var title: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(singleNews.source).fontWeight(.semibold)
                Text(singleNews.calculateTimeDiff())
            }
            .foregroundColor(.gray).font(.caption)
            Text(singleNews.headline).fontWeight(.bold)
        }
    }
    
    var image: some View {
        AsyncImage(
            url: singleNews.image,
            content: { image in
                image
                    .resizable()
                    .frame(maxWidth: 100, maxHeight: 100)
                    .scaledToFill()
                    .cornerRadius(10)
            },
            placeholder: {
                ProgressView()
            }
        )
    }
}


struct SingleNewsView_Previews: PreviewProvider {
    static var previews: some View {
        headNews(singleNews: SingleNews.example3())
//        normalSingleNews(singleNews: SingleNews.example2())
    }
}
