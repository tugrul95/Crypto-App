//
//  StatisticsView.swift
//  Crypto
//
//  Created by Macbook on 18.01.2022.
//

import SwiftUI

struct StatisticsView: View {
    
    let statistic: Statistics
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(statistic.title)
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
            Text(statistic.value)
                .font(.headline)
                .foregroundColor(Color.theme.accent)
            HStack(spacing: 4) {
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(Angle(degrees: (statistic.percentageChange ?? 0) >= 0 ? 0 : 180))
                Text(statistic.percentageChange?.asPercentString() ?? "")
                    .font(.caption)
                    .fontWeight(.bold)
            }
            .foregroundColor((statistic.percentageChange ?? 0) >= 0 ? Color.theme.green : Color.theme.red)
            .opacity(statistic.percentageChange == nil ? 0.0 : 1.0)
        }
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StatisticsView(statistic: sample.statisticA)
                .previewLayout(.sizeThatFits)
                .padding()
            StatisticsView(statistic: sample.statisticB)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
                .padding()
            StatisticsView(statistic: sample.statisticC)
                .previewLayout(.sizeThatFits)
                .padding()
        }
    }
}
