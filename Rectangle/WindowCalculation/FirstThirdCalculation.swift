//
//  LeftThirdCalculation.swift
//  Rectangle
//
//  Created by Ryan Hanson on 7/26/19.
//  Copyright © 2019 Ryan Hanson. All rights reserved.
//

import Foundation

class FirstThirdCalculation: WindowCalculation, OrientationAware {
    
    override func calculateRect(_ window: Window, lastAction: RectangleAction?, visibleFrameOfScreen: CGRect, action: WindowAction) -> RectResult {
        guard Defaults.subsequentExecutionMode.value != .none,
            let last = lastAction, let lastSubAction = last.subAction else {
            return orientationBasedRect(visibleFrameOfScreen)
        }
        
        var calculation: WindowCalculation?
        
        if last.action == .firstThird {
            switch lastSubAction {
            case .topThird, .leftThird:
                calculation = WindowCalculationFactory.centerThirdCalculation
            case .centerHorizontalThird, .centerVerticalThird:
                calculation = WindowCalculationFactory.lastThirdCalculation
            default:
                break
            }
        } else if last.action == .lastThird {
            switch lastSubAction {
            case .topThird, .leftThird:
                calculation = WindowCalculationFactory.centerThirdCalculation
            default:
                break
            }
        }
        
        if let calculation = calculation {
            return calculation.calculateRect(window, lastAction: lastAction, visibleFrameOfScreen: visibleFrameOfScreen, action: action)
        }
        
        return orientationBasedRect(visibleFrameOfScreen)
    }
    
    func landscapeRect(_ visibleFrameOfScreen: CGRect) -> RectResult {
        var rect = visibleFrameOfScreen
        rect.size.width = floor(visibleFrameOfScreen.width / 3.0)
        return RectResult(rect, subAction: .leftThird)
    }
    
    func portraitRect(_ visibleFrameOfScreen: CGRect) -> RectResult {
        var rect = visibleFrameOfScreen
        rect.size.height = floor(visibleFrameOfScreen.height / 3.0)
        rect.origin.y = visibleFrameOfScreen.minY + visibleFrameOfScreen.height - rect.height
        return RectResult(rect, subAction: .topThird)
    }

}
