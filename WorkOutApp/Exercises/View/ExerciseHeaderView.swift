//
//  ExerciseHeaderView.swift
//  WorkOutApp
//
//  Created by Joao Barros on 14/05/23.
//

import UIKit
import SwiftUI

protocol ExerciseHeaderViewDelegate: AnyObject {
    func addPressed()
    func searchBarTextChanged(text: String)
}

class ExerciseHeaderView: UITableViewHeaderFooterView {
    
    //MARK: - Properties

    weak var delegate: ExerciseHeaderViewDelegate?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.text = "Exercise"
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Create your own customized Exercise 💪"
        return label
    }()
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Exercise", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(pressAdd), for: .touchUpInside)
        return button
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search by exercise title"
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
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(actionButton)
        addSubview(searchBar)

        titleLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 50, paddingLeft: 30)
        descriptionLabel.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 30, paddingRight: 16)
        actionButton.anchor(top: topAnchor, right: rightAnchor,paddingTop: 16, paddingRight: 16, width: 120, height: 40)
        searchBar.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 16, paddingBottom: 16, paddingRight: 16)
        backgroundView = UIView(frame: bounds)
        backgroundView?.backgroundColor = .lightGray
    }

    //MARK: - Private

    @objc private func pressAdd() {
        delegate?.addPressed()
    }
}

//MARK: - UISearchBarDelegate

extension ExerciseHeaderView: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        delegate?.searchBarTextChanged(text: searchText)
    }
}


//MARK: - Preview

struct ExerciseHeaderViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> ExerciseHeaderView {
        return ExerciseHeaderView()
    }
    func updateUIView(_ uiView: ExerciseHeaderView, context: Context) {
    }
}

struct ExerciseHeaderViewCell_Preview: PreviewProvider {
    static var previews: some View {
        ExerciseHeaderViewRepresentable()
            .previewLayout(. fixed (width: 400, height: 200))
    }
}
