//
//  SearchViewModel.swift
//  QulixTest
//
//  Created by Ujin Artuhovich on 26.11.21.
//

import Foundation

final class SearchViewModel {
    public var dataViewUpdated: ((Result<[MainModel], CustomError>) -> ())?
    
    public func getData(with request: String) {
        APiClinet.shared.fetchSearchData(with: request) { result in
            switch result {
            case .failure(let error):
                self.dataViewUpdated?(.failure(error))
            case .success(let data):
                self.dataViewUpdated?(.success(data.items))
            }
        }
    }
    
    public func stopRequest() {
        APiClinet.shared.cancelTask()
    }
}
