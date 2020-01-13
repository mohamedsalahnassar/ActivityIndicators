//
//  DefaultIndicator.swift
//  ActivityIndicators
//
//  Created by Inal Gotov on 2020-01-11.
//  Copyright © 2020 Inal Gotov. All rights reserved.
//

import SwiftUI

extension Indicator {
    struct Default: ActivityIndicator {
        @Binding var isAnimating: Bool
        var color = Color.primary
        
        /// The current rotation of the ball string.
        @State private var rotation: Double = 0
        /// The timer which drives the animation of this indicator.
        private let timer = Timer.publish(every: 1 / 12, on: .main, in: .common).autoconnect()
        
        var body: some View {
            GeometryReader { proxy in
                ForEach(0...11, id: \.self) { index in
                    ZStack {
                        Rectangle()
                            .fill(self.color)
                            .frame(width: self.width(proxy),
                                   height: self.height(proxy))
                            .position(x: proxy.frame(in: .local).midX,
                                      y: proxy.frame(in: .local).minY + (self.height(proxy) / 2))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .opacity(1 - (Double(index) / 12))
                    .rotationEffect(.radians(-2 * Double.pi * (Double(index) / 12)))
                }
            }
            .frame(width: 40, height: 40)
            .rotationEffect(.degrees(self.rotation))
            .animation(.none)
            .onReceive(self.timer) { _ in
                if self.isAnimating {
                    // % not available, and truncatingRemainder is not correct
                    var newValue = self.rotation + 30
                    if newValue >= 360 {
                        newValue -= 360
                    }
                    self.rotation = newValue
                }
            }
        }
        
        /// Returns the width of a single line of the indicator.
        /// - Parameter proxy: The GeometryProxy representing the container of this Activity Indicator.
        func width(_ proxy: GeometryProxy) -> CGFloat {
            minDimension(proxy) * 0.07
        }
        
        /// Returns the height of a single line of the indicator.
        /// - Parameter proxy: The GeometryProxy representing the container of this Activity Indicator.
        func height(_ proxy: GeometryProxy) -> CGFloat {
            (minDimension(proxy) / 2) - (minDimension(proxy) * 0.25)
        }
    }
}

struct DefaultIndicator_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Indicator.Default(isAnimating: .constant(true), color: .yellow)
            Indicator.Default(isAnimating: .constant(false))
        }
    }
}
