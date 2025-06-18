//
//  ShoppingDetailViewController.swift
//  ShoppingApp
//
//  Created by Caroline Neuman on 2025-06-18.
//

import UIKit

class ShoppingDetailViewController: UIViewController {
    
    private let viewModel: ShoppingDetailViewModel
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    init(viewModel: ShoppingDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = viewModel.title
        setupUI()
        configureViews()
    }
}

private extension ShoppingDetailViewController {
    
    func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
    }
    
    func configureViews() {
        if let image = viewModel.image {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
            stackView.addArrangedSubview(imageView)
        }
        
        let titleLabel = UILabel()
        titleLabel.font = .boldSystemFont(ofSize: 22)
        titleLabel.numberOfLines = 0
        titleLabel.text = viewModel.title
        stackView.addArrangedSubview(titleLabel)
        
        let priceLabel = UILabel()
        priceLabel.textColor = .systemGreen
        priceLabel.font = .systemFont(ofSize: 18)
        priceLabel.text = viewModel.priceText
        stackView.addArrangedSubview(priceLabel)
        
        let descriptionLabel = UILabel()
        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = viewModel.description
        stackView.addArrangedSubview(descriptionLabel)
    }
}
