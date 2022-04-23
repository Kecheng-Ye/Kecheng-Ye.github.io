//
//  Toast.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/13/22.
//

import SwiftUI

struct Toast<Presenting>: View where Presenting: View {

    /// The binding that decides the appropriate drawing in the body.
    @Binding var isShowing: Bool
    @Binding var counter: Int
    /// The view that will be "presenting" this toast
    let presenting: () -> Presenting
    /// The text to show
    let text: Text

    var body: some View {

        GeometryReader { geometry in
            ZStack(alignment: .center) {
                presenting()
                
                if self.isShowing {
                    VStack {
                        Spacer()
                        self.text
                            .frame(width: geometry.size.width / 1.5,
                                    height: geometry.size.height / 10)
                            .background(.gray)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .transition(.slide)
                    }
                    .onAppear {
                        Timer.scheduledTimer(withTimeInterval: TOAST_DURATION, repeats: false) { timer in
                            self.counter -= 1
                            
                            if self.counter == 0 {
                                withAnimation {
                                    self.isShowing = false
                                }
                            }
                        }
                    }
                }
            }
        }

    }

}

extension View {
    func toast(isShowing: Binding<Bool>, counter: Binding<Int>, text: Text) -> some View {
        Toast(isShowing: isShowing,
              counter: counter,
              presenting: { self },
              text: text)
    }
}
