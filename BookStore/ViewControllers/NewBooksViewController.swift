//
//  NewBooksViewController.swift
//  BookStore
//
//  Created by Soojin Ro on 10/06/2019.
//  Copyright © 2019 Soojin Ro. All rights reserved.
//

import UIKit
import BookStoreKit

final class NewBooksViewController: UIViewController {
    private(set) var books = [Book]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        reload()
    }
    
    private func setupTableView() {
        tableView?.register(BookCell.self)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.rowHeight = 250
        tableView?.estimatedRowHeight = 250
        tableView?.tableFooterView = UIView()
        tableView?.accessibilityIdentifier = "NewBooksTableView"
    }
    
    private func reload() {
        state = .loading
        bookStore.fetchNewReleases(completionHandler: handle)
    }
    
    private func handle(_ result: Result<NewBooksResponse, Error>) {
        switch result {
        case .success(let response):
            books = response.books
            state = books.isEmpty ? .empty : .finished
            tableView?.reloadData()
        case .failure:
            state = .error
        }
    }
    
    @IBAction private func retryButtonTapped(_ sender: UIButton) {
        reload()
    }
    
    private lazy var bookStore: BookStoreService = unspecified()
    @IBOutlet private weak var tableView: UITableView?
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView?
    @IBOutlet private weak var statusLabel: UILabel?
    @IBOutlet private weak var retryButton: UIButton?
    
    private enum LoadingState {
        case loading, finished, empty, error
    }
    
    private var state: LoadingState = .empty {
        didSet {
            switch state {
            case .loading:
                tableView?.isHidden = true
                statusLabel?.text = "Loading"
                retryButton?.isHidden = true
                activityIndicatorView?.startAnimating()
            case .finished:
                tableView?.isHidden = false
                statusLabel?.text = nil
                retryButton?.isHidden = true
                activityIndicatorView?.stopAnimating()
            case .empty:
                tableView?.isHidden = true
                statusLabel?.text = "Nothing new 🙃"
                retryButton?.isHidden = true
                activityIndicatorView?.stopAnimating()
            case .error:
                tableView?.isHidden = true
                statusLabel?.text = "Something went wrong 🤯"
                retryButton?.isHidden = false
                activityIndicatorView?.stopAnimating()
            }
        }
    }
}

extension NewBooksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(BookCell.self, for: indexPath)
        
        let book = books[indexPath.row]
        
        cell.identifier = book.isbn13
        cell.titleLabel?.text = book.title
        cell.subtitleLabel?.text = book.subtitle
        cell.priceLabel?.text = book.price
        cell.isbn13Label?.text = book.isbn13
        
        if let thumbnailURL = book.thumbnailURL {
            ImageProvider.shared.fetch(from: thumbnailURL) { (result) in
                if case .success(let image) = result, cell.identifier == book.isbn13 {
                    cell.thumbnailImageView?.image = image
                }
            }
        }
        
        return cell
    }
}

extension NewBooksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = books[indexPath.row]
        let bookInfoViewController = BookInfoViewController.instantiate(isbn13: book.isbn13, bookStore: bookStore)
        present(bookInfoViewController, animated: true, completion: nil)
    }
}

extension NewBooksViewController: BookStoreView {
    func set(_ bookStore: BookStoreService) {
        self.bookStore = bookStore
    }
}
