//
//  InsightsView.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/14/22.
//

import SwiftUI

struct InsightsView: View {
    let socialSentiments: SocialSentimentList
    let companyBrief: CompanyBrief
    let recommendInfos: RecommendInfos
    let earningInfos: EarningInfos
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Insights").subTitlefy()
            
            SocialSentimentView(
                socialSentiments: socialSentiments,
                companyBrief: companyBrief
            )
            
            RecommendationChart(recommendInfos: recommendInfos)
            
            EarningChart(earningInfos: earningInfos)
        }
        .frame(minHeight: 1200)
    }
}

struct InsightsView_Previews: PreviewProvider {
    static var previews: some View {
        InsightsView(
            socialSentiments: SocialSentimentList.example(),
            companyBrief: CompanyBrief.example(),
            recommendInfos: RecommendInfoList(),
            earningInfos: EarningInfoList()
        )
    }
}
