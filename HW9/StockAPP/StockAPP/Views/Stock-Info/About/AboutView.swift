//
//  About.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/14/22.
//

import SwiftUI

struct AboutView: View {
    let companyBrief: CompanyBrief
    let peers: Peers
    
    var body: some View {
        VStack(alignment: .leading){
            Text("About").subTitlefy()
            
            aboutInfo.contentfy()
        }
    }
    
    var aboutInfo: some View {
        VStack(alignment: .leading, spacing: 15) {
            IPO
            Industry
            Webpage
            CompanyPeers
        }
        .fullWidth()
    }
    
    var IPO: some View {
        fullWidthBinaryHStack(
            left: Text("IPO Start Date:").fontWeight(.bold),
            right: Text(companyBrief.ipo)
        )
    }
    
    var Industry: some View {
        fullWidthBinaryHStack(
            left: Text("Industry:").fontWeight(.bold),
            right: Text(companyBrief.finnhubIndustry)
        )
    }
    
    var Webpage: some View {
        fullWidthBinaryHStack(
            left: Text("Webpage:").fontWeight(.bold),
            right: Link("\(companyBrief.weburl!.absoluteString)",
                        destination: companyBrief.weburl!)
        )
    }
    
    var CompanyPeers: some View {
        fullWidthBinaryHStack(
            left: Text("CompanyPeers:").fontWeight(.bold),
            right: peerStocks
        )
    }
    
//    var lables: some View {
//        VStack(alignment: .leading, spacing: 15) {
//            Text("IPO Start Date:").fontWeight(.bold)
//            Text("Industry:").fontWeight(.bold)
//            Text("Webpage:").fontWeight(.bold)
//            Text("CompanyPeers:").fontWeight(.bold)
//        }
//    }
//    
//    var values: some View {
//        VStack(alignment: .leading, spacing: 15) {
//            Text(companyBrief.ipo)
//            Text(companyBrief.finnhubIndustry)
//            Link("\(companyBrief.weburl!.absoluteString)",
//                 destination: companyBrief.weburl!)
//            peerStocks
//        }
//    }
    
    var peerStocks: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(peers, id: \.self) { peer in
                    NavigationLink(destination: SingleStockInfo(stockTicker: peer)) {
                        Text(peer).linkify()
                    }
                }
            }
        }
    }
}

struct About_Previews: PreviewProvider {
    static var previews: some View {
        AboutView(companyBrief: CompanyBrief.example(), peers: peersExample())
    }
}
