//
//  MainViewController.swift
//  QulixTest
//
//  Created by Ujin Artuhovich on 26.11.21.
//

import UIKit

class MainViewController: UIViewController {
    private let searchBar: UISearchBar
    private let viewModel: SearchViewModel
    private let mainView: MainView
    
    init(
        viewModel: SearchViewModel,
        mainView: MainView
    ) {
        self.searchBar = UISearchBar()
        self.viewModel = viewModel
        self.mainView = mainView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        createView()
        updateView()
        searched()
        stoped()
    }
    
    private func updateView() {
        viewModel.dataViewUpdated = { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                self.mainView.viewState = .success(data: data)
            case .failure(let error):
                self.mainView.viewState = .fatalError(error: error)
            }
        }
    }
    
    // Function for google search button, which react on completion
    private func searched() {
        mainView.searched = { [weak self] in
            guard let self = self else { return }
            
            self.startLoading()
        }
    }
    
    // Function for stop button, which react on completion
    private func stoped() {
        mainView.stoped = { [weak self] in
            guard let self = self else { return }
            
            self.viewModel.stopRequest()
            self.mainView.viewState = .initial
            self.searchBar.resignFirstResponder()
        }
    }
    
    private func createView() {
        view.addSubview(mainView)
        mainView.viewState = .initial
        mainView.frame = view.frame
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        startLoading()
    }
}

// start loading extension
extension MainViewController {
    private func startLoading() {
        guard let text = searchBar.text else { return }
        
        viewModel.getData(with: text)
        mainView.viewState = .loading
        searchBar.resignFirstResponder()
    }
}
