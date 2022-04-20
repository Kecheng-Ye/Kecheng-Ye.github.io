//
//  SocialSentimentView.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/14/22.
//

import SwiftUI

struct SocialSentimentView: View {
    let socialSentiments: SocialSentimentList
    let companyBrief: CompanyBrief
    
    var body: some View {
        let (reddit, twitter) = socialSentiments.conclusionForPlot()
        
        VStack {
            Text("Social Sentiments").font(.title)
                .fullWidth()
            
            HStack(spacing: 20) {
                Label
                Record(Title: "Reddit", of: reddit)
                Record(Title: "Twitter", of: twitter)
            }
        }
    }
    
    var Label: some View {
        VStack(alignment: .leading) {
            Divider()
            Text(companyBrief.name).fontWeight(.bold).listItemfy()
            Divider()
            Text("Total Mentions").fontWeight(.bold).listItemfy()
            Divider()
            Text("Postive Mentions").fontWeight(.bold).listItemfy()
            Divider()
            Text("Negative Mentions").fontWeight(.bold).listItemfy()
            Divider()
        }
        .fullWidth()
    }
    
    func Record(Title: String, of record: SentimentConclusion) -> some View {
        VStack(alignment: .leading) {
            Divider()
            Text("\(Title)").fontWeight(.bold).listItemfy()
            Divider()
            Text(numberFormat(record.Total)).listItemfy()
            Divider()
            Text(numberFormat(record.Positive)).listItemfy()
            Divider()
            Text(numberFormat(record.Negative)).listItemfy()
            Divider()
        }
        .fullWidth()
    }
}

struct SocialSentimentView_Previews: PreviewProvider {
    static var previews: some View {
        SocialSentimentView(
            socialSentiments: SocialSentimentList.example(),
            companyBrief: CompanyBrief.example()
        )
    }
}

func numberFormat(_ value: Int32) -> String {
    return NumberFormatter.localizedString(from: NSNumber(value: value), number: NumberFormatter.Style.decimal)
}

struct listItem: ViewModifier {
    func body(content: Content) -> some View {
        content.frame(width: 100, height: 45, alignment: .leading)
    }
}


extension View {
    func listItemfy() -> some View {
        self.modifier(listItem())
    }
}
