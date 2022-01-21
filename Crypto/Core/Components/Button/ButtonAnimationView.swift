//
//  CircleButtonAnimationView.swift
//  Crypto
//
//  Created by Macbook on 18.01.2022.
//

import SwiftUI

struct ButtonAnimationView: View {
    
    @Binding var animate: Bool
    
    var body: some View {
        Circle()
            .stroke(lineWidth: 5.0)
            .scale(animate ? 1.0 : 0.0)
            .opacity(animate ? 0.0 : 1.0)
            .animation(animate ? .easeOut(duration: 1) : .none, value: animate)

    }
}

struct ButtonAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonAnimationView(animate: .constant(false))
            .foregroundColor(.red)
            .frame(width: 100, height: 100)
    }
}
