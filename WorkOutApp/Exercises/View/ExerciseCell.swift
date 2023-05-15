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
        label.numberOfLines = 2
        return label
    }()

    private let notesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        label.text = "Arms strong"
        label.numberOfLines = 3
        return label
    }()

    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        return view
    }()

    private let imageViewIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "photo")
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
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
        addSubview(imageViewIcon)
        imageViewIcon.anchor(top: topAnchor, bottom: bottomAnchor, right: rightAnchor, paddingRight: 16, width: 90, height: 90)
        nameLabel.anchor(top: topAnchor, left: leftAnchor, right: imageViewIcon.leftAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 10)
        notesLabel.anchor(top: nameLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: imageViewIcon.leftAnchor, paddingTop: 4, paddingLeft: 16,paddingBottom: 10 ,paddingRight: 10)
        lineView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 1)
    }

    func setup() {
        if let exercise {
            imageViewIcon.isHidden = true
            nameLabel.text = exercise.nameLabel
            notesLabel.text = exercise.notesLabel
            if let image = exercise.exerciseImage {
                imageViewIcon.isHidden = false
                imageViewIcon.image = UIImage(data: image)
            }
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
            .previewLayout(. fixed (width: 400, height: 100))
    }
}

