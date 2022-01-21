//
//  MiniChartView.swift
//  Crypto
//
//  Created by Macbook on 18.01.2022.
//

import SwiftUI

struct MiniChartView: View {
    
    private let data: [Double]
    private let maxY: Double
    private let minY: Double
    private let lineColor: Color
    
    init(coin: Coin) {
        var todaysData: [Double] = []
        // Each Double in Sparkline is 1HR of the last 7DAYS
        // Remove 144HRS to get the most recent 24HRS
        if let sparkline = coin.sparklineIn7D?.price, sparkline.count > 144 {
            var weeksData = sparkline
            weeksData.removeFirst(144)
            todaysData = weeksData
            
        }
        data = todaysData
        maxY = data.max() ?? 0
        minY = data.min() ?? 0
        
        lineColor = coin.priceChangePercentage24H ?? 0 >= 0 ? Color.theme.green : Color.theme.red
    }
    
    var body: some View {
        VStack {
            chartView.frame(height: 30)
                .background(chartLine)
        }
    }
}

struct MiniChartView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CoinRowView(coin: sample.coin, showHoldingsColumn: false)
                .previewLayout(.sizeThatFits)
            MiniChartView(coin: sample.coin)
                .previewLayout(.sizeThatFits)
        }
    }
}

extension MiniChartView {
    private var chartView: some View {
        GeometryReader { geometry in
            Path { path in
                for index in data.indices {
                    let xPos = geometry.size.width / CGFloat(data.count) * CGFloat(index + 1)
                    
                    let yAxis = maxY - minY
                    let yPos = (1 - CGFloat((data[index] - minY)) / yAxis) * geometry.size.height
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: xPos, y: yPos))
                    }
                    path.addLine(to: CGPoint(x: xPos, y: yPos))
                }
            }
            .stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
        }
    }
    
    private var chartLine: some View {
        GeometryReader { geometry in
            Path { path in
                if let start = data.first {
                    let xPos = geometry.size.width / CGFloat(data.count)
                    let yAxis = maxY - minY
                    let yPos = (1 - CGFloat((start - minY)) / yAxis) * geometry.size.height
                    path.move(to: CGPoint(x: xPos, y: yPos))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: yPos))
                }
            }
            .stroke(Color.theme.secondaryText, style: StrokeStyle(lineWidth: 0.5, lineCap: .round, lineJoin: .round, dash: [4]))
        }
    }
}
