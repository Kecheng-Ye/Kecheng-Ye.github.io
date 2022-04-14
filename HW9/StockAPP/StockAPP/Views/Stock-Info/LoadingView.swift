//
//  LoadingView.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/10/22.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
            Text("Fetching Data...").foregroundColor(.gray)
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
