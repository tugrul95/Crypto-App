//
//  HomeStatisticsView.swift
//  Crypto
//
//  Created by Macbook on 18.01.2022.
//

import SwiftUI

struct HomeStatisticsView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @Binding var showPortfolio: Bool
    
    var body: some View {
        HStack(alignment: .top) {
            ForEach(vm.statistics) { statistic in
                StatisticsView(statistic: statistic)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }
        .frame(width: UIScreen.main.bounds.width, alignment: showPortfolio ? .trailing : .leading)
        .padding(.vertical)
    }
}

struct HomeStatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        HomeStatisticsView(showPortfolio: .constant(false))
            .environmentObject(sample.vm)
    }
}
