//
//  NewsView.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/16/22.
//

import SwiftUI

struct NewsView: View {
    let news: News
    
    var body: some View {
        let filteredNews = filterNews(rawNewsList: news)
        
        VStack(alignment: .leading) {
            Text("News").subTitlefy()
            
            headNews(singleNews: filteredNews[0]).fullWidth()
            
            Divider()
            
            ForEach(filteredNews[1...]) { oneNews in
                normalSingleNews(singleNews: oneNews).fullWidth()
            }
        }
    }
}

struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        NewsView(news: newsExample())
    }
}
