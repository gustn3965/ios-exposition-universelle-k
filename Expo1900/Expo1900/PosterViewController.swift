//
//  PosterViewController.swift
//  Expo1900
//
//  Created by Jinwook Huh on 2022/01/11.
//

import UIKit

class PosterViewController: UIViewController {
    lazy var titleLabel: UILabel = makeLabel(with: .title1)
    
    lazy var posterImageView: UIImageView = makeImageView(imageName: "poster")
    
    lazy var visitorStaticLabel: UILabel = makeLabel(with: .title3, text: "방문객")
    lazy var locationStaticLabel: UILabel = makeLabel(with: .title3, text: "개최지")
    lazy var durationStaticLabel: UILabel = makeLabel(with: .title3, text: "개최 기간")
    
    lazy var visitorLabel: UILabel = makeLabel(with: .body)
    lazy var locationLabel: UILabel = makeLabel(with: .body)
    lazy var durationLabel: UILabel = makeLabel(with: .body)
    
    lazy var visitorStackView: UIStackView = makeHorizontalStackView(with: visitorStaticLabel, visitorLabel, spacing: 5)
    lazy var locationStackView: UIStackView = makeHorizontalStackView(with: locationStaticLabel, locationLabel, spacing: 5)
    lazy var durationStackView: UIStackView = makeHorizontalStackView(with: durationStaticLabel, durationLabel, spacing: 5)
    
    lazy var descriptionLabel: UILabel = makeLabel(with: .body)

    lazy var leftFlagImageView: UIImageView = makeImageView(imageName: "flag")
    lazy var rightFlagImageView: UIImageView = makeImageView(imageName: "flag")
    
    lazy var showExpoButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("한국의 출품작 보러가기", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var buttonStackView: UIStackView = makeHorizontalStackView(with: leftFlagImageView, showExpoButton, rightFlagImageView, spacing: 20)
    
    lazy var contentStackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [titleLabel, posterImageView,
                                                                    visitorStackView, locationStackView,
                                                                    durationStackView, descriptionLabel,
                                                                    buttonStackView])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 7
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    lazy var scrollView: UIScrollView = {
        let scrollView: UIScrollView = UIScrollView()
        scrollView.addSubview(contentStackView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupScrollView()
        bindExpositionModel()
    }
    
    private func makeLabel(with style: UIFont.TextStyle, text: String = "") -> UILabel {
        let label: UILabel = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: style)
        label.textColor = UIColor.black
        label.text = text
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func makeHorizontalStackView(with subviews: UIView..., spacing: CGFloat) -> UIStackView {
        let stackView: UIStackView = UIStackView(arrangedSubviews: subviews)
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    private func makeImageView(imageName: String) -> UIImageView {
        let imageView: UIImageView = UIImageView()
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([scrollView.topAnchor.constraint(equalTo: view.topAnchor),
                                     scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                     scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
                                     contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                                     contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                                     contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                                     contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)])
        setupImageViews()
    }
    
    private func setupImageViews() {
        let safeArea: UILayoutGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([posterImageView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.4),
                                     posterImageView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.6),
                                     leftFlagImageView.heightAnchor.constraint(equalToConstant: 20),
                                     leftFlagImageView.widthAnchor.constraint(equalToConstant: 20),
                                     rightFlagImageView.heightAnchor.constraint(equalToConstant: 20),
                                     rightFlagImageView.widthAnchor.constraint(equalToConstant: 20)])
    }
    
    private func bindExpositionModel() {
        guard let jsonData: Data = FileLoader.shared.readFile(fileName: "exposition_universelle_1900", extensionType: "json") else {
            return
        }
        
        let model: Exposition? = JSONParser.shared.decode(Exposition.self, from: jsonData)
        guard let model = model else {
            return
        }

        titleLabel.text = model.title
        visitorLabel.text = ": \(model.visitors)"
        locationLabel.text = ": \(model.location)"
        durationLabel.text = ": \(model.duration)"
        descriptionLabel.text = "\(model.description)"
    }
}