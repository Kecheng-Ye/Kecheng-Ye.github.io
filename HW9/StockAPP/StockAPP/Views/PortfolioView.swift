//
//  PortfolioView.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/16/22.
//

import SwiftUI

struct PortfolioView: View {
    @EnvironmentObject var userProfileVM: UserProfileVM
    @EnvironmentObject var priceQuery: PriceQuery
    
    var body: some View {
        Section(header: Text("PORTFOLIO")) {
            Text("portfolio")
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
    }
}
