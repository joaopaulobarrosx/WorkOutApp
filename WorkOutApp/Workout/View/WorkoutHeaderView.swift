//
//  WorkoutHeaderView.swift
//  WorkOutApp
//
//  Created by Joao Barros on 13/05/23.
//

import UIKit
import SwiftUI

protocol WorkoutHeaderViewDelegate: AnyObject {
    func logoutUser()
    func addPressed()
    func searchBarTextChanged(text: String)
}

class WorkoutHeaderView: UITableViewHeaderFooterView {
    
    //MARK: - Properties

    weak var delegate: WorkoutHeaderViewDelegate?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.text = "Workout App"
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Create your own customized workout 💪"
        return label
    }()
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Workout", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(pressAdd), for: .touchUpInside)
        return button
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(pressLogout), for: .touchUpInside)
        return button
    }()

    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search by workout title"
        searchBar.barTintColor = .lightGray
        return searchBar
    }()
    
    //MARK: - Init
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
        searchBar.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    
    private func setupViews() {
        addSubview(logoutButton)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(actionButton)
        addSubview(searchBar)
        logoutButton.anchor(top: topAnchor, left: leftAnchor, paddingTop: 10, paddingLeft: 10, width: 70, height: 30)
        titleLabel.anchor(top: logoutButton.bottomAnchor, left: leftAnchor, paddingTop: 20, paddingLeft: 30)
        descriptionLabel.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 30, paddingRight: 16)
        actionButton.anchor(top: topAnchor, right: rightAnchor,paddingTop: 16, paddingRight: 16, width: 120, height: 40)
        searchBar.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 16, paddingBottom: 16, paddingRight: 16)
        backgroundView = UIView(frame: bounds)
        backgroundView?.backgroundColor = .lightGray
    }

    //MARK: - Private

    @objc private func pressLogout() {
        delegate?.logoutUser()
    }

    @objc private func pressAdd() {
        delegate?.addPressed()
    }
}

//MARK: - UISearchBarDelegate

extension WorkoutHeaderView: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        delegate?.searchBarTextChanged(text: searchText)
    }
}


//MARK: - Preview

struct WorkoutHeaderViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> WorkoutHeaderView {
        return WorkoutHeaderView()
    }
    func updateUIView(_ uiView: WorkoutHeaderView, context: Context) {
    }
}

struct WorkoutHeaderView_Preview: PreviewProvider {
    static var previews: some View {
        WorkoutHeaderViewRepresentable()
            .previewLayout(. fixed (width: 400, height: 200))
    }
}
