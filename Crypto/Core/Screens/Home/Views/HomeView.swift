//
//  HomeView.swift
//  Crypto
//
//  Created by Macbook on 18.01.2022.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @State private var showPortfolio: Bool = false
    @State private var showPortfolioView: Bool = false
    @State private var showInfoView: Bool = false
    @State private var selectedCoin: Coin?
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
                .sheet(isPresented: $showPortfolioView) {
                    PortfolioView()
                        .environmentObject(vm)
                }
            VStack {
                homeHeader
                SearchBarView(searchText: $vm.searchText)
                HomeStatisticsView(showPortfolio: $showPortfolio)
                columnTitles
                if !showPortfolio {
                    allCoinsList
                        .transition(.move(edge: .trailing))
                } else {
                    ZStack(alignment: .top) {
                        if vm.portfolioCoins.isEmpty && vm.searchText.isEmpty {
                            emptyPortfolioText
                        } else {
                            portfolioCoinsList
                        }
                    }
                    .transition(.move(edge: .leading))
                }
            }
        }
        .background(
            NavigationLink(isActive: $showInfoView, destination: {
                InfoLoadingView(coin: $selectedCoin)
            }, label: {
                EmptyView()
            })
        )
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                HomeView()
                    .navigationBarHidden(true)
            }
            .environmentObject(sample.vm)
            NavigationView {
                HomeView()
                    .navigationBarHidden(true)
            }
            .previewDevice("iPhone 13 Pro Max")
            .environmentObject(sample.vm)
        }
    }
}

extension HomeView {
    private var homeHeader: some View {
        HStack {
            ZStack {
                Image("logo-transparent")
                .resizable()
                .frame(width: 40, height: 40)
                .opacity(showPortfolio ? 0.0 : 1.0)
                
                IconButtonView(iconName: "plus")
                    .animation(.none, value: UUID())
                    .onTapGesture {
                        showPortfolioView.toggle()
                    }
                    .background(
                        ButtonAnimationView(animate: $showPortfolio)
                            .foregroundColor(Color.theme.green)
                    )
                    .opacity(showPortfolio ? 1.0 : 0.0)
            }
            
            
            if showPortfolio {

            } else {

            }
            Spacer()
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
                .animation(nil, value: UUID())
            Spacer()
            IconButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? -180 : 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }
    
    private var allCoinsList: some View {
        List {
            ForEach(vm.allCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: false)
                    .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        lazyNavigate(coin: coin)
                    }
            }
        }
        .listStyle(.plain)
        .refreshable {
            vm.reloadData()
        }
        
    }
    
    private var portfolioCoinsList: some View {
        List {
            ForEach(vm.portfolioCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: true)
                    .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        lazyNavigate(coin: coin)
                    }
            }
        }
        .listStyle(.plain)
        .refreshable {
            vm.reloadData()
        }
    }
    
    private var emptyPortfolioText: some View {
        VStack {
            Spacer()
            Text("Portfolio is Empty")
                .font(.callout)
                .fontWeight(.medium)
                .foregroundColor(Color.theme.secondaryText)
            Spacer()
        }
    }
    
    private func lazyNavigate(coin: Coin) {
        selectedCoin = coin
        showInfoView.toggle()
    }
    
    private var columnTitles: some View {
        HStack {
            HStack(spacing: 4) {
                Text("Coins")
                Image(systemName: "chevron.down")
                    .opacity(vm.sortOption == .rank || vm.sortOption == .rankReversed ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .rank ? 0 : 180))
            }
            .onTapGesture {
                withAnimation {
                    vm.sortOption = vm.sortOption == .rank ? .rankReversed : .rank
                }
            }
            Spacer()
            if showPortfolio {
                HStack(spacing: 4) {
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity(vm.sortOption == .holdings || vm.sortOption == .holdingsReversed ? 1.0 : 0.0)
                        .rotationEffect(Angle(degrees: vm.sortOption == .holdings ? 0 : 180))
                }
                .onTapGesture {
                    withAnimation {
                        vm.sortOption = vm.sortOption == .holdings ? .holdingsReversed : .holdings
                    }
                }
            }
            HStack(spacing: 4) {
                Text("Price")
                Image(systemName: "chevron.down")
                    .opacity(vm.sortOption == .price || vm.sortOption == .priceReversed ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .price ? 0 : 180))
            }
            .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
            .onTapGesture {
                withAnimation {
                    vm.sortOption = vm.sortOption == .price ? .priceReversed : .price
                }
            }
            
            Button {
                withAnimation(.linear(duration: 2.0)) {
                    vm.reloadData()
                }
            } label: {
                Image(systemName: "goforward")
                    .rotationEffect(Angle(degrees: vm.isLoading ? 360 : 0), anchor: .center)
            }
            
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal)
    }
}
