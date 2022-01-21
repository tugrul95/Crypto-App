//
//  InfoView.swift
//  Crypto
//
//  Created by Macbook on 18.01.2022.
//

import SwiftUI


struct InfoLoadingView: View {
    
    @Binding var coin: Coin?
    
    var body: some View {
        ZStack {
            if let coin = coin {
                InfoView(coin: coin)
            }
        }
    }
}

struct InfoView: View {
    
    @StateObject private var vm: InfoViewModel
    @State private var showFullDescription: Bool = false
    
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    private let spacing: CGFloat = 30
        
    init(coin: Coin) {
        _vm = StateObject(wrappedValue: InfoViewModel(coin: coin))
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ChartView(coin: vm.coin)
                    .padding(.vertical)
                VStack(spacing: 20) {
                    overviewTitle
                    Divider()
                    descriptionSection
                    overviewGrid
                    additionalTitle
                    Divider()
                    additionalGrid
                    websiteSection
                }
                .padding()
            }
        }
        .background(Color.theme.background)
        .navigationTitle(vm.coin.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                navigationTrailingItem
            }
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            InfoView(coin: sample.coin)
        }
    }
}

extension InfoView {
    private var descriptionSection: some View {
        ZStack {
            if let coinDescription = vm.coinDescription, !coinDescription.isEmpty {
                VStack(alignment: .leading) {
                    Text(coinDescription)
                        .lineLimit(showFullDescription ? nil : 3)
                        .font(.callout)
                        .foregroundColor(Color.theme.secondaryText)
                    Button {
                        withAnimation(.easeInOut) {
                            showFullDescription.toggle()
                        }
                    } label: {
                        Text(showFullDescription ? "Show less" : "Read more")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.vertical, 4)
                    }
                    .tint(.blue)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    private var websiteSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            if let website = vm.coinWebsite, let url = URL(string: website) {
                Link("Website", destination: url)
            }
            if let reddit = vm.coinSubreddit, let url = URL(string: reddit) {
                Link("Reddit", destination: url)
            }
        }
        .tint(.blue)
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.headline)
    }
    
    private var overviewTitle: some View {
        Text("Overview")
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var additionalTitle: some View {
        Text("Additional")
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var overviewGrid: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: spacing, pinnedViews: []) {
            ForEach(vm.overviewStatistics) { statistic in
                StatisticsView(statistic: statistic)
            }
        }
    }
    
    private var additionalGrid: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: spacing, pinnedViews: []) {
            ForEach(vm.additionalStatistics) { statistic in
                StatisticsView(statistic: statistic)
            }
        }
    }
    
    private var navigationTrailingItem: some View {
        HStack {
            Text(vm.coin.symbol.uppercased())
                .font(.headline)
            .foregroundColor(Color.theme.secondaryText)
            CoinImageView(coin: vm.coin)
                .frame(width: 25, height: 25)
        }
    }
}
