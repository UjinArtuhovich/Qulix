//
//  MainView.swift
//  QulixTest
//
//  Created by Ujin Artuhovich on 26.11.21.
//

import Foundation
import UIKit

class MainView: UIView {
    private var tableView: UITableView
    private var dataSource: MainTableDataSource
    
    public var stoped: (() -> ())?
    public var searched: (() -> ())?
    
    init() {
        self.tableView = UITableView(frame: .zero, style: .plain)
        self.dataSource = MainTableDataSource()
        super.init(frame: .zero)
        addSubviews()
        makeConstraints()
        initTableView()
    }
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView()
        return ai
    }()
    
    private lazy var goggleSearchButton: UIButton = {
        let gsb = UIButton()
        gsb.layer.cornerRadius = 15
        gsb.backgroundColor = .green
        gsb.setTitle("Google Search", for: .normal)
        gsb.setTitleColor(.black, for: .normal)
        gsb.titleLabel?.font = .preferredFont(forTextStyle: .subheadline)
        gsb.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        return gsb
    }()
    
    private lazy var stopButton: UIButton = {
        let sb = UIButton()
        sb.layer.cornerRadius = 15
        sb.backgroundColor = .red
        sb.setTitle("Stop", for: .normal)
        sb.setTitleColor(.black, for: .normal)
        sb.titleLabel?.font = .preferredFont(forTextStyle: .subheadline)
        sb.addTarget(self, action: #selector(stopButtonTapped), for: .touchUpInside)
        return sb
    }()
    
    private lazy var errorLabel: UILabel = {
        let el = UILabel()
        el.numberOfLines = 0
        el.textAlignment = .center
        el.font = .preferredFont(forTextStyle: .headline)
        return el
    }()
    
    var viewState: MainViewState = .initial {
        didSet {
            switch viewState {
            case .initial:
                tableView.isHidden = true
                goggleSearchButton.isHidden = false
                stopButton.isHidden = true
                activityIndicator.stopAnimating()
                errorLabel.isHidden = true
                
            case .loading:
                stopButton.isHidden = false
                goggleSearchButton.isHidden = true
                tableView.isHidden = true
                errorLabel.isHidden = true
                activityIndicator.startAnimating()
                
            case .success(let data):
                dataSource.update(with: data)
                tableView.reloadData()
                goggleSearchButton.isHidden = false
                stopButton.isHidden = true
                activityIndicator.stopAnimating()
                tableView.isHidden = false
                
            case .fatalError(let error):
                goggleSearchButton.isHidden = false
                stopButton.isHidden = true
                activityIndicator.stopAnimating()
                errorLabel.text = error.localizedErrorDescription
                errorLabel.isHidden = false
            }
        }
    }
    
    private func addSubviews() {
        self.addSubviews(views: [
            goggleSearchButton,
            stopButton,
            tableView,
            activityIndicator,
            errorLabel
        ])
    }
    
    private func makeConstraints() {
        /// searchButton constraints
        goggleSearchButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            goggleSearchButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            goggleSearchButton.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            goggleSearchButton.heightAnchor.constraint(equalToConstant: 50),
            goggleSearchButton.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
        ])
        
        /// stopButton constraints
        stopButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stopButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            stopButton.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            stopButton.heightAnchor.constraint(equalToConstant: 50),
            stopButton.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
        ])
        
        /// tableView constraints
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: goggleSearchButton.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
        ])
        
        /// activityIndicator constraints
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        /// errorLabel constraints
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
        ])
    }
    
    private func initTableView() {
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(
            UINib(nibName: String(describing: MainTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: "mainCell"
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func searchButtonTapped() {
        searched?()
    }
    
    @objc func stopButtonTapped() {
        stoped?()
    }
}

extension MainView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

