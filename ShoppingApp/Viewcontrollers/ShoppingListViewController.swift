//
//  ViewController.swift
//  ShoppingApp
//
//  Created by Caroline Neuman on 2025-06-18.
//

import UIKit

class ShoppingListViewController: UITableViewController {
    
    private let viewModel: ShoppingListViewModel
    private let spinner = UIActivityIndicatorView(style: .large)
    
    init(viewModel: ShoppingListViewModel) {
        self.viewModel = viewModel
        super.init(style: .grouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ShoppingApp"
        setupUI()
        setupBinding()
        spinner.startAnimating()
        viewModel.fetchData()
    }
}

// MARK: - Setup UI

extension ShoppingListViewController {
    
    func setupUI() {
        
        tableView.register(ProductCell.self, forCellReuseIdentifier: "Cell")
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func setupBinding() {
        viewModel.onUpdate = { [weak self] in
            guard let self else { return }
            spinner.stopAnimating()
            tableView.reloadData()
        }
        
        viewModel.onError = { [weak self] error in
            guard let self else { return }
            spinner.stopAnimating()
            showError(error: error)
        }
    }
    
}

//MARK: - Private methods

private extension ShoppingListViewController {
    
    func showError(error: Error) {
        let message = (error as? ProductError)?.localizedDescription ?? error.localizedDescription
        let alert = UIAlertController(title: "Error",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension ShoppingListViewController {
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.sections[section].title
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.sections[section].products.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let product = viewModel.sections[indexPath.section].products[indexPath.row]
        let image = ProductImage.image(id: product.id, models: viewModel.productImages)
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ProductCell
        cell?.configure(product: product, image: image)
        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let product = viewModel.sections[indexPath.section].products[indexPath.row]
        let image = ProductImage.image(id: product.id, models: viewModel.productImages)
        let vm = ShoppingDetailViewModel(product: product, image: image)
        let vc = ShoppingDetailViewController(viewModel: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
}
