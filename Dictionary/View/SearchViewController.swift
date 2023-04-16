//
//  SearchViewController.swift
//  Dictionary
//
//  Created by Sinan Ulusoy on 25.03.2023.
//

import UIKit

final class SearchViewController: UIViewController {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var recentSearchTableView: UITableView!
    @IBOutlet private weak var bottomSearchView: UIView!
    @IBOutlet private weak var searchViewBottomConstraint: NSLayoutConstraint!

    private let searchViewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupView()
        setupKeyboardObserver()
    }
    
    private func setup() {
        searchViewModel.delegate = self
        searchBar.delegate = self
        searchViewModel.config()        
    }

    private func setupView() {
        let recentSearchTVHeader = UIView(
            frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 80))
        let recentSearchLabel = UILabel(
            frame: CGRect(x: 20, y: 0, width: view.frame.size.width, height: 80))
        recentSearchTVHeader.addSubview(recentSearchLabel)
        
        recentSearchLabel.text = K.RecentSearch.headerLabel
        recentSearchLabel.font = UIFont.systemFont(ofSize: 17.0)
        recentSearchLabel.textColor = UIColor(hexString: "#686868")
        
        recentSearchTableView.tableHeaderView = recentSearchTVHeader
        recentSearchTableView.delegate = self
        recentSearchTableView.dataSource = self
        recentSearchTableView.rowHeight = 44
        recentSearchTableView.separatorStyle = .none
        
        searchBar.searchBarStyle = .minimal
        
        let bottomSearchViewGesture = UITapGestureRecognizer(
            target: self, action: #selector(self.didPressBottomSearchView(_:)))
        bottomSearchView.addGestureRecognizer(bottomSearchViewGesture)
    }
}


extension SearchViewController: SearchViewModelProtocol {
    
    func reloadData() {
        recentSearchTableView.reloadDataAsync()
    }
}


// MARK: - SearchViewController delegates
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchViewModel.recentSearchListCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Id.recentSeachTVCell, for: indexPath) as! RecentSearchTableViewCell
        let searchList = searchViewModel.getRecentSearchList()
        cell.recentSearchLabel.text = searchList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! RecentSearchTableViewCell
        let storyBoard: UIStoryboard = UIStoryboard(name: K.Id.storyBoard, bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: K.Id.detailVC) as! DetailViewController
        vc.word = cell.recentSearchLabel.text ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


// MARK: - SearchBar actions
extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            searchViewModel.appendNewSearch(text)
            let storyBoard: UIStoryboard = UIStoryboard(name: K.Id.storyBoard, bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: K.Id.detailVC) as! DetailViewController
            newViewController.word = text
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }
    
    @objc private func didPressBottomSearchView(_ sender: UITapGestureRecognizer) {
        searchBarSearchButtonClicked(searchBar)
    }
}


// MARK: - Keyboard toggle actions
extension SearchViewController {
    
    private func setupKeyboardObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(SearchViewController.keyboardToggle),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(SearchViewController.keyboardToggle),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }

    @objc private func keyboardToggle(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        switch notification.name {
        case UIResponder.keyboardWillHideNotification:
            searchViewBottomConstraint.constant = 0
        case UIResponder.keyboardWillShowNotification:
            searchViewBottomConstraint.constant = keyboardSize.height
        default:
            return
        }
        
        let keyboardDuration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let keyboardCurve = UIView.AnimationCurve(rawValue: notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! Int)!
        let animator = UIViewPropertyAnimator(duration: keyboardDuration, curve: keyboardCurve) { [weak self] in
            self?.view.layoutIfNeeded()
        }
        animator.startAnimation()
    }
}
