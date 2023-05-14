//
//  WorkoutCell.swift
//  WorkOutApp
//
//  Created by Joao Barros on 13/05/23.
//

import UIKit
import SwiftUI

class WorkoutCell: UITableViewCell {

    //MARK: - Properties
    
    var workout: Workout?

    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.text = "Arms"
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        label.text = "Arms strong"
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.text = "Created at 16/05/2023"
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
//        selectionStyle = .none
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Setup

    private func setupViews() {
        backgroundColor = .workOutBackgroundLight
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(dateLabel)
        addSubview(lineView)

        titleLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 16)
        descriptionLabel.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 16, paddingRight: 16)
        dateLabel.anchor(top: descriptionLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, paddingTop: 4, paddingLeft: 16, paddingBottom: 8)
        lineView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 1)
    }

    func configure(title: String, description: String, date: Date) {
        titleLabel.text = title
        descriptionLabel.text = description

        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        dateLabel.text = formatter.string(from: date)
    }

    func setup() {
        if let workout {
            titleLabel.text = workout.workoutTitle
            descriptionLabel.text = workout.descriptionLabel

            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            let date = formatter.string(from: workout.createdLabel ?? Date())
            dateLabel.text = "Created at \(date)"
        }
    }
}

//MARK: - Preview

struct WorkoutCellRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> WorkoutCell {
        return WorkoutCell()
    }
    func updateUIView(_ uiView: WorkoutCell, context: Context) {
    }
}

struct WorkoutCell_Preview: PreviewProvider {
    static var previews: some View {
        WorkoutCellRepresentable()
            .previewLayout(. fixed (width: 400, height: 80))
    }
}
