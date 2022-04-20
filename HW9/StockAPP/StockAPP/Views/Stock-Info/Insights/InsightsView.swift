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
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Insights").subTitlefy()
            SocialSentimentView(
                socialSentiments: socialSentiments,
                companyBrief: companyBrief
            )
        }
    }
}

struct InsightsView_Previews: PreviewProvider {
    static var previews: some View {
        InsightsView(
            socialSentiments: SocialSentimentList.example(),
            companyBrief: CompanyBrief.example()
        )
    }
}
