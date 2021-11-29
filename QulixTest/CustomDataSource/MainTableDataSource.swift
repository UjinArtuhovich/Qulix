//
//  MainTableDataSource.swift
//  QulixTest
//
//  Created by Ujin Artuhovich on 27.11.21.
//

import Foundation
import UIKit

class MainTableDataSource: NSObject, UITableViewDataSource {
    private var results: [MainModel]?
    
    public func update(with data: [MainModel]) {
        self.results = data
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let results = results else { return 0 }
        
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let results = results else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as! MainTableViewCell
        cell.configure(with: results[indexPath.row])
        return cell
    }
    
    
}
