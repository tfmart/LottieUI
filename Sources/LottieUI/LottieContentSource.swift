//
//  LottieContentSource.swift
//  
//
//  Created by Tomas Martins on 20/04/22.
//

import Lottie
import Foundation

internal enum LottieContentSource {
    case bundle(name: String,
                bunle: Bundle,
                imageProvider: AnimationImageProvider?,
                animationCache: AnimationCacheProvider?)
    
    case filepath(path: String,
                  animationCache: AnimationCacheProvider?)
    
    case async(url: URL,
               imageProvider: AnimationImageProvider?,
               closure: AnimationView.DownloadClosure,
               animationCache: AnimationCacheProvider?)
}
