//
//  TransactionSheet.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/18/22.
//

import SwiftUI
import Combine

enum TransactionStatus {
    case Pending
    case BuySuccess
    case SellSuccess
}

struct TransactionSheet: View {
    @EnvironmentObject var userProfileVM: UserProfileVM
    @EnvironmentObject var priceQuery: PriceQuery
    @EnvironmentObject var briefQuery: BriefQuery
    let companyBrief: CompanyBrief
    let currentPrice: CurrentPrice
    @State var status = TransactionStatus.Pending
    @State var numShares: String = ""
    @State var noBuyPower: Bool = false
    @State var noBuyPowerCounter: Int = 0
    @State var noSellPower: Bool = false
    @State var noSellPowerCounter: Int = 0
    @State var negativeBuy: Bool = false
    @State var negativeBuyCounter: Int = 0
    @State var negativeSell: Bool = false
    @State var negativeSellCounter: Int = 0
    @State var wrongInput: Bool = false
    @State var wrongInputCounter: Int = 0
    
    var body: some View {
        ZStack {
            if status == TransactionStatus.Pending {
                Color.white
            } else {
                Color("transactionGreen").ignoresSafeArea()
            }
            
            switch status {
            case .Pending: trasactionPage
            case .BuySuccess: buySuccessPage
            case .SellSuccess: sellSuccessPage
            }
        }
    }
    
    var trasactionPage: some View {
        VStack(alignment: .leading) {
            dissmissBtn
            title
            Spacer()
            input
            Spacer()
            balance
            transactionBtns
        }
        .toast(isShowing: $noBuyPower, counter: $noBuyPowerCounter,
               text: Text("Not enough money to buy"))
        .toast(isShowing: $noSellPower, counter: $noSellPowerCounter,
               text: Text("Not enough shares to sell"))
        .toast(isShowing: $negativeBuy, counter: $negativeBuyCounter,
               text: Text("Cannot buy non-positive shares"))
        .toast(isShowing: $negativeSell, counter: $negativeSellCounter,
               text: Text("Cannot sell non-positive shares"))
        .toast(isShowing: $wrongInput, counter: $wrongInputCounter,
               text: Text("Please enter a valid amount"))
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
        Text("Trade \(companyBrief.name) shares")
            .font(.title3)
            .fontWeight(.bold)
            .fullWidth(alignment: .center)
    }
    
    var input: some View {
        VStack(alignment: .trailing) {
            HStack {
                TextField("0", text: $numShares)
                    .keyboardType(.numberPad)
                    .font(.system(size: 65))
                    .onReceive(Just(numShares)) { newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if filtered != newValue {
                            openWrongInputToast()
                            self.numShares = ""
                        }
                    }
                Text("Share").font(.system(size: 40))
            }
            
            Text("x $\(roundToTwoDecimal(currentPrice.currentPrice))/share = $\(roundToTwoDecimal(transactionAmount()))")
        }
    }
    
    var balance: some View {
        Text("$\(roundToTwoDecimal(userProfileVM.balance)) avaliable to buy \(companyBrief.ticker)")
            .foregroundColor(.gray)
            .font(.subheadline)
            .fullWidth(alignment: .center)
    }
    
    var transactionBtns: some View {
        HStack(spacing: 25) {
            buyBtn
            sellBtn
        }
        .fullWidth(alignment: .center)
        
    }
    
    var buyBtn: some View {
        Button(action: buyAction) {
            Text("Buy")
                .font(.body)
                .foregroundColor(.white)
                .frame(width: 120)
        }
        .padding()
        .background(.green)
        .clipShape(Capsule())
    }
    
    var sellBtn: some View {
        Button(action: sellAction) {
            Text("Sell")
                .font(.body)
                .foregroundColor(.white)
                .frame(width: 120)
        }
        .padding()
        .background(.green)
        .clipShape(Capsule())
    }
    
    var buySuccessPage: some View {
        VStack {
            Spacer()
            Text("Congratulations!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.vertical, 20)
            Text("You have successfully bought \(Int(self.numShares) ?? 0) of \(companyBrief.ticker)").foregroundColor(.white)
            Spacer()
            Button(action: closesheet) {
                Text("Done")
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(Color("transactionGreen"))
                    .frame(width: 300, height: 50)
            }
            .background(.white)
            .clipShape(Capsule())
            .padding(.bottom, 40)
        }
        .fullWidth(alignment: .center)
    }
    
    var sellSuccessPage: some View {
        VStack {
            Spacer()
            Text("Congratulations!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.vertical, 20)
            Text("You have successfully sold \(Int(self.numShares) ?? 0) of \(companyBrief.ticker)").foregroundColor(.white)
            Spacer()
            Button(action: closesheet) {
                Text("Done")
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(Color("transactionGreen"))
                    .frame(width: 300, height: 50)
            }
            .background(.white)
            .clipShape(Capsule())
            .padding(.bottom, 40    )
        }
        .fullWidth(alignment: .center)
    }
    
    func transactionAmount() -> Price {
        return ((Float(self.numShares) ?? 0.0) * currentPrice.currentPrice)
    }
    
    func buyAction() {
        let limit = userProfileVM.balance
        let target = transactionAmount()
        
        if target > limit {
            openNoBuyPowerToast()
        } else if target <= 0 {
            openNegativeBuyToast()
        } else {
            MainPageUpdate(for: companyBrief.ticker)
            
            userProfileVM.buyStock(
                stockTicker: companyBrief.ticker,
                record: Trasaction(
                    price: currentPrice.currentPrice,
                    shares: (Int(self.numShares) ?? 0)
               )
            )
            
            withAnimation {
                status = .BuySuccess
            }
        }
    }
    
    func sellAction() {
        let limit = userProfileVM.portfolio[companyBrief.ticker]?.sharesRemain ?? 0
        let target = (Int(self.numShares) ?? 0)
        
        if target <= 0 {
            openNegativeSellToast()
        } else if target > limit {
            openNoSellPowerToast()
        } else {
            userProfileVM.sellStock(
                stockTicker: companyBrief.ticker,
                record: Trasaction(
                    price: currentPrice.currentPrice,
                    shares: (Int(self.numShares) ?? 0)
                )
            )
                        
            withAnimation {
                status = .SellSuccess
            }
        }
    }
    
    func clearToast() {
        noBuyPower = false
        noSellPower = false
        negativeBuy = false
        negativeSell = false
        wrongInput = false
        noSellPower = false
    }
    
    func openNoBuyPowerToast() {
        clearToast()
        noBuyPower = true
        noBuyPowerCounter += 1
    }
    
    func openNegativeBuyToast() {
        clearToast()
        negativeBuy = true
        negativeBuyCounter += 1
    }
    
    func openWrongInputToast() {
        clearToast()
        wrongInput = true
        wrongInputCounter += 1
    }
    
    func openNegativeSellToast() {
        clearToast()
        negativeSell = true
        negativeSellCounter += 1
    }
    
    func openNoSellPowerToast() {
        clearToast()
        noSellPower = true
        noSellPowerCounter += 1
    }
    
    func MainPageUpdate(for stockTicker: String) {
        priceQuery.updateOneStock(for: stockTicker, data: currentPrice)
        briefQuery.updateOneStock(for: stockTicker, data: companyBrief)
    }
}

struct TransactionSheet_Previews: PreviewProvider {
    static var previews: some View {
        TransactionSheet(companyBrief: CompanyBrief.example(), currentPrice: CurrentPrice.example2()).environmentObject(UserProfileVM())
    }
}
