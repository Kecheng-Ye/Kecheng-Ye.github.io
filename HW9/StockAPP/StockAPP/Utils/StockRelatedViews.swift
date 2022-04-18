//
//  StockRelatedViews.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/14/22.
//

import SwiftUI

@ViewBuilder
func priceArrow(_ priceChange: Price) -> some View {
    if priceChange > 0 {
        Image(systemName: "arrow.up.right")
    } else if priceChange < 0 {
        Image(systemName: "arrow.down.right")
    }
}

func fullWidthBinaryHStack<T: View, V: View>(left: T, right: V,
                                             alignment1: Alignment = .leading,
                                             alignment2: Alignment = .leading) -> some View {
    HStack(spacing: 0) {
        left.frame(minWidth: 0, maxWidth: .infinity, alignment: alignment1)
        right.frame(minWidth: 0, maxWidth: .infinity, alignment: alignment2)
    }
    .frame(minWidth: 0, maxWidth: .infinity)
}

struct stockColor: ViewModifier {
    let priceChange: Price
    
    func body(content: Content) -> some View {
        content.foregroundColor(
            priceChange > 0 ? .green :
                priceChange < 0 ? .red : .black
        )
    }
}

struct section: ViewModifier {
    func body(content: Content) -> some View {
        content.fullWidth().padding(.bottom, 20)
    }
}

struct subTitle: ViewModifier {
    func body(content: Content) -> some View {
        content.font(.largeTitle).padding(.bottom)
    }
}

struct content: ViewModifier {
    func body(content: Content) -> some View {
        content.font(.footnote)
    }
}

struct link: ViewModifier {
    func body(content: Content) -> some View {
        content.foregroundColor(.blue)
    }
}

struct fullWidthContainer: ViewModifier {
    let alignment: Alignment
    
    init(alignment: Alignment) {
        self.alignment = alignment
    }
    
    func body(content: Content) -> some View {
        content.frame(minWidth: 0, maxWidth: .infinity, alignment: self.alignment)
    }
}

func margin(for width: Double) -> Double {
    guard !width.isZero else { return 0 }
    return width >= 414 ? 20 : 16
}

extension View {
    func stockColorify(priceChange: Price) -> some View {
        self.modifier(stockColor(priceChange: priceChange))
    }
    
    func subTitlefy() -> some View {
        self.modifier(subTitle())
    }
    
    func contentfy() -> some View {
        self.modifier(content())
    }
    
    func linkify() -> some View {
        self.modifier(link())
    }
    
    func sectionfy() -> some View {
        self.modifier(section())
    }
    
    func fullWidth(alignment: Alignment = .leading) -> some View {
        self.modifier(fullWidthContainer(alignment: alignment))
    }
}

struct EdgeBorder: Shape {

    var width: CGFloat
    var edges: [Edge]

    func path(in rect: CGRect) -> Path {
        var path = Path()
        for edge in edges {
            var x: CGFloat {
                switch edge {
                case .top, .bottom, .leading: return rect.minX
                case .trailing: return rect.maxX - width
                }
            }

            var y: CGFloat {
                switch edge {
                case .top, .leading, .trailing: return rect.minY
                case .bottom: return rect.maxY - width
                }
            }

            var w: CGFloat {
                switch edge {
                case .top, .bottom: return rect.width
                case .leading, .trailing: return self.width
                }
            }

            var h: CGFloat {
                switch edge {
                case .top, .bottom: return self.width
                case .leading, .trailing: return rect.height
                }
            }
            path.addPath(Path(CGRect(x: x, y: y, width: w, height: h)))
        }
        return path
    }
}

extension View {
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}
