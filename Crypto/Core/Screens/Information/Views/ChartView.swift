//
//  ChartView.swift
//  Crypto
//
//  Created by Macbook on 18.01.2022.
//

import SwiftUI

struct ChartView: View {
    
    @State private var percentage: CGFloat = 0
    @State private var position: CGPoint?
    
    private let data: [Double]
    private let maxY: Double
    private let minY: Double
    private let lineColor: Color
    private let startingDate: Date
    private let endingDate: Date

    
    init(coin: Coin) {
        data = coin.sparklineIn7D?.price ?? []
        maxY = data.max() ?? 0
        minY = data.min() ?? 0
        
        let priceChange = (data.last ?? 0) - (data.first ?? 0)
        lineColor = priceChange > 0 ? Color.theme.green : Color.theme.red
        
        endingDate = Date(coinGeckoDate: coin.lastUpdated ?? "")
        startingDate = endingDate.addingTimeInterval(-7*24*60*60)
        
    }
    
    var body: some View {
        VStack {
            chartView
                .frame(height: 200)
                .background(chartBackground)
                .overlay(chartMarker)
                .overlay(chartOverlay.padding(.horizontal, 4), alignment: .leading)
            chartDates.padding(.horizontal, 4)
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .gesture(
            DragGesture(minimumDistance: 0, coordinateSpace: .local)
                .onChanged { value in
                    position = value.location
                }
                .onEnded { _ in
                    position = nil
                }
        )
        .onAppear {
            withAnimation(.linear(duration: 2)) {
                percentage = 1
            }
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(coin: sample.coin)
    }
}

extension ChartView {
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
            .trim(from: 0, to: percentage)
            .stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            .shadow(color: lineColor, radius: 10, x: 0, y: 0)
        }
    }
    
    private var chartMarker: some View {
        GeometryReader { geometry in
            if let position = position, position.x < geometry.size.width && position.x > 0 {
                let index = Int(position.x / (geometry.size.width / CGFloat(data.count)))
                let xPos = geometry.size.width / CGFloat(data.count) * CGFloat(index + 1)
                let yPos = (1 - CGFloat((data[index] - minY)) / (maxY - minY)) * geometry.size.height
                
                ZStack(alignment: .topTrailing) {
                    Circle()
                        .frame(width: 10, height: 10)
                        .position(x: xPos, y: yPos)
                        .foregroundColor(lineColor)
                    Text("$\(data[index])")
                         .font(.headline)
                         .foregroundColor(Color.theme.accent)
                }
            }
        }
    }
    
    private var chartBackground: some View {
        VStack {
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }
    
    private var chartOverlay: some View {
        VStack {
            Text(maxY.formattedWithAbbreviations())
            Spacer()
            Text(((maxY + minY) / 2).formattedWithAbbreviations())
            Spacer()
            Text(minY.formattedWithAbbreviations())
        }
    }
    
    private var chartDates: some View {
        HStack {
            Text(startingDate.asShortDateString())
            Spacer()
            Text("7 Day Chart")
                .fontWeight(.bold)
            Spacer()
            Text(endingDate.asShortDateString())
        }
    }
}
