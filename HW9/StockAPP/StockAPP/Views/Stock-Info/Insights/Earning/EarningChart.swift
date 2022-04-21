//
//  EarningChart.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/21/22.
//

import SwiftUI

struct EarningChart: View {
    let earningInfos: EarningInfos
    
    var body: some View {
        WebView(
            fileName: "EarningChart",
            fileDirectory: "Charts/EarningChart/",
            JSONData: dataToJSON()
        )
    }
    
    func dataToJSON() -> String {
        let (categories, actual, estimate) = EarningInfoListToHighChartDraw(earningInfos)

        let encodedJSON = encodeJSON(
            [
                "categories": (categories, Array<String>.self),
                "actual": (actual, Array<Float32>.self),
                "estimate": (estimate, Array<Float32>.self),
            ]
        )
                
        return encodedJSON
    }
}

struct EarningChart_Previews: PreviewProvider {
    static var previews: some View {
        EarningChart(earningInfos: EarningInfoList())
    }
}
