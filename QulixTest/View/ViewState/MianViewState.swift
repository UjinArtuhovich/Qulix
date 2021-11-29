//
//  MianViewState.swift
//  QulixTest
//
//  Created by Ujin Artuhovich on 27.11.21.
//

import Foundation

enum MainViewState {
    case initial
    case loading
    case success(data: [MainModel])
    case fatalError(error: CustomError)
}
