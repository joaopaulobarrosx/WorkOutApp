//
//  ExerciseCell.swift
//  WorkOutApp
//
//  Created by Joao Barros on 14/05/23.
//

import UIKit
import SwiftUI

class ExerciseCell: UITableViewCell {

    //MARK: - Properties
    
    var exercise: Exercise?

    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.text = "Arms"
        return label
    }()

    private let notesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        label.text = "Arms strong"
        return label
    }()

    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        return view
    }()

    //MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Setup

    private func setupViews() {
        backgroundColor = .workOutBackgroundLight
        addSubview(nameLabel)
        addSubview(notesLabel)
        addSubview(lineView)

        nameLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 16)
        notesLabel.anchor(top: nameLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 16, paddingRight: 16)
        lineView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 1)
    }

    func setup() {
        if let exercise {
            nameLabel.text = exercise.nameLabel
            notesLabel.text = exercise.notesLabel
        }
    }
}

//MARK: - Preview

struct ExerciseCellRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> ExerciseCell {
        return ExerciseCell()
    }
    func updateUIView(_ uiView: ExerciseCell, context: Context) {
    }
}

struct ExerciseCell_Preview: PreviewProvider {
    static var previews: some View {
        ExerciseCellRepresentable()
            .previewLayout(. fixed (width: 400, height: 80))
    }
}

