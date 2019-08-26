//
//  SearchViewController.swift
//  BookStore
//
//  Created by Soojin Ro on 12/06/2019.
//  Copyright © 2019 Soojin Ro. All rights reserved.
//

import UIKit
import BookStoreKit

final class SearchViewController: UIViewController {
    private(set) var books = [Book]()

    override func viewDidLoad() {
        super.viewDidLoad()

        books = []
        searchEngine.delegate = self
        setupViews()
    }
    
    func focusSearchBar() {
        searchBar?.becomeFirstResponder()
    }
    
    private func setupViews() {
        searchBar?.delegate = self
        messageLabel?.text = nil
        activityIndicator?.stopAnimating()
        
        tableView?.register(BookCell.self)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.prefetchDataSource = self
        tableView?.rowHeight = 250
        tableView?.estimatedRowHeight = 250
        tableView?.tableFooterView = UIView()
        tableView?.accessibilityIdentifier = "SearchTableView"
    }
    
    private func handleSuccess(_ result: SearchResult) {
        if result.request.page == 1 {
            books = result.books
            tableView?.reloadData()
            tableView?.animateFadeIn()
        } else {
            books.append(contentsOf: result.books)
            tableView?.reloadData()
        }
        tableView?.tableFooterView = UIView()
    }
    
    private func handleError(_ error: Error) {
        messageLabel?.text = searchBar?.text?.isEmpty == true ? nil : error.localizedDescription
        activityIndicator?.layoutIfNeeded()
        
        switch error {
        case SearchError.notFound:
            books = []
        case SearchError.endOfResult:
            tableView?.tableFooterView = endOfResultFooterView
        default:
            ()
        }
        
        errorMessageView?.animateFadeIn()
    }
    
    private var searchEngine: SearchEngine {
        return bookStore.searchEngine
    }
    
    private lazy var bookStore: BookStoreService = unspecified()
    @IBOutlet private weak var searchBar: UISearchBar?
    @IBOutlet private weak var tableView: UITableView?
    @IBOutlet private weak var errorMessageView: UIView?
    @IBOutlet private weak var messageLabel: UILabel?
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView?
    @IBOutlet private var endOfResultFooterView: UIView?
}

extension SearchViewController: SearchEngineDelegate {
    func searchEngine(_ engine: SearchEngine, didStart searchRequest: SearchRequest) {
        activityIndicator?.startAnimating()
        if searchRequest.page == 1 {
            UIView.animateFadeOut([tableView, errorMessageView])
            tableView?.contentOffset = .zero
            activityIndicator?.animateFadeIn()
        }
    }
    
    func searchEngine(_ engine: SearchEngine, didReceive searchResult: Result<SearchResult, SearchError>) {
        activityIndicator?.animateFadeOut()
        activityIndicator?.stopAnimating()
        
        searchResult.success(handleSuccess)
                    .catch(handleError)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            UIView.animateFadeOut([tableView, errorMessageView])
        } else {
            searchEngine.search(for: searchText)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
    }
}

extension SearchViewController: UITableViewDataSource {
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
        cell.thumbnailImageView?.image = nil
        
        if let thumbnailURL = book.thumbnailURL {
            ImageProvider.shared.fetch(from: thumbnailURL) { (result) in
                if cell.identifier == book.isbn13 {
                    cell.thumbnailImageView?.image = try? result.get()
                }
            }
        }
        
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = books[indexPath.row]
        let bookInfoViewController = BookInfoViewController.instantiate(isbn13: book.isbn13, bookStore: bookStore)
        present(bookInfoViewController, animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let trigger = scrollView.contentSize.height - (tableView?.rowHeight ?? 0) * 6
        
        if scrollView.contentOffset.y > trigger && searchEngine.hasNextPage {
            searchEngine.requestNextPage()
        }
    }
}

extension SearchViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let thumbnailURLs = indexPaths.compactMap { books[$0.row].thumbnailURL }
        thumbnailURLs.forEach { ImageProvider.shared.fetch(from: $0) }
    }
}

extension SearchViewController: BookStoreView {
    func set(_ bookStore: BookStoreService) {
        self.bookStore = bookStore
    }
}
