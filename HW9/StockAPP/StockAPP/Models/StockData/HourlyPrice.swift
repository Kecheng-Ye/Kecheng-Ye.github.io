//
//  HourlyPrice.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/10/22.
//

import Foundation

struct HourlyPrice: Codable, APILinkable, APIDebugable, ReflectedStringConvertible, Dependable {
    typealias DependDataType = TimeInterval
    
    let closePrices: [Price]
    let timestamps: [TimeInterval]
    var dependData: DependDataType = NATime
    
    enum CodingKeys: String, CodingKey {
        case closePrices = "c"
        case timestamps = "t"
    }
    
    init() {
        closePrices = []
        timestamps = []
    }
    
    init(closePrices: [Price], timestamps: [TimeInterval]) {
        self.closePrices = closePrices
        self.timestamps = timestamps
    }
    
    static func example() -> HourlyPrice {
        HourlyPrice(
            closePrices:
                [
                152.1, 151.64, 151.71, 151.59, 151.74, 151.61, 151.9, 151.83, 152.13,
                152.36, 151.84, 151.8, 151.88, 151.43, 151.5, 151.53, 152.1, 152.01, 152.55,
                152.98, 152.72, 152.46, 152.34, 153.11, 153.615, 153.49, 153.44, 153.32,
                152.93, 152.88, 152.98, 153.16, 153.75, 153.98, 153.9153, 153.8867, 153.515,
                153.6401, 153.0299, 153.08, 153.01, 152.61, 152.3675, 152.2301, 152.53,
                152.485, 152.093, 151.58, 151.73, 152.0701, 152.005, 151.9698, 151.475,
                151.56, 151.8057, 151.62, 151.1299, 150.98, 150.645, 150.5152, 150.69,
                150.8701, 151.0001, 150.8003, 150.665, 150.7219, 150.92, 150.67, 151.27,
                151.0021, 151.04, 151.2462,
                ],
            timestamps:
                [
                1647259800, 1647260100, 1647260400, 1647260700, 1647261000, 1647261300,
                1647261600, 1647261900, 1647262200, 1647262500, 1647262800, 1647263100,
                1647263400, 1647263700, 1647264000, 1647264300, 1647264600, 1647264900,
                1647265200, 1647265500, 1647265800, 1647266100, 1647266400, 1647266700,
                1647267000, 1647267300, 1647267600, 1647267900, 1647268200, 1647268500,
                1647268800, 1647269100, 1647269400, 1647269700, 1647270000, 1647270300,
                1647270600, 1647270900, 1647271200, 1647271500, 1647271800, 1647272100,
                1647272400, 1647272700, 1647273000, 1647273300, 1647273600, 1647273900,
                1647274200, 1647274500, 1647274800, 1647275100, 1647275400, 1647275700,
                1647276000, 1647276300, 1647276600, 1647276900, 1647277200, 1647277500,
                1647277800, 1647278100, 1647278400, 1647278700, 1647279000, 1647279300,
                1647279600, 1647279900, 1647280200, 1647280500, 1647280800, 1647281100,
                ]
        )
    }
    
    func API_URL(stockTicker: String) -> URL? {
        return URL(string: APILink + "hour-charts/\(stockTicker)" + "?start=\(Int(self.dependData))")
    }
    
    func APIExample() -> HourlyPrice {
        return Self.example()
    }
    
    func toHighChartDraw() -> [[Price]] {
        var result: [[Price]] = []
        
        for i in 0..<self.closePrices.count {
            result.append([Float(self.timestamps[i] * 1000), self.closePrices[i]])
        }
        
        return result
    }
}

protocol Dependable {
    associatedtype DependDataType
    var dependData: DependDataType { get set }
    
    mutating func updateDependData(data: DependDataType)
}

extension Dependable {
    mutating func updateDependData(data: DependDataType) {
        self.dependData = data
    }
}
