//
//  AsyncLottiePhase.swift
//  
//
//  Created by Tomas Martins on 06/05/22.
//

import SwiftUI

public enum AsyncLottiePhase {
    case loading
    case error
    case success(LottieView)
}
