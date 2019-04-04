//
//  ViewController.swift
//  NasaMediaLibrary
//
//  Created by Dharamshi, Lopa D on 4/2/19.
//  Copyright © 2019 Dharamshi Lopa D. All rights reserved.
//

import UIKit

class NasaMediaLibraryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mediaLibraryViewSpinner: UIActivityIndicatorView!
    @IBOutlet weak var informatoryLabel: UILabel!
    
    private enum mediaViewControllerStates:Int {
        case searchNotStarted
        case searchBegan
        case searchEndedWithResults
        case searchFailedWithoutResults
    }
    
    private var mediaLibraryListViewModel:NasaMediaLibraryViewModel?
    
    private enum identifiers {
        static let listCellIdentifier = "nasa library list cell"
        static let segueIdentifier = "show nasa image details"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    private func setUpView(){

        self.updateUI(for: .searchNotStarted)
        self.navigationItem.title = "Search Nasa Media Library"
        tableView.separatorColor = .gray
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
//        tableView.register(NasaLibraryListTableViewCell.self, forCellReuseIdentifier: CellIdentifiers.list)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier{
        case identifiers.segueIdentifier:
            if let detailViewController = segue.destination as? NasaLibraryDetailsViewController, let selectedCell = sender as? NasaLibraryListTableViewCell, let selectedIndexPath = tableView.indexPath(for: selectedCell) {
                detailViewController.detailModel = mediaLibraryListViewModel?.nasaMediaLibraryModel(at: selectedIndexPath.row)

            }
        default: break
        }
    }
    
    private func updateUI(for state:mediaViewControllerStates){
        switch state {
        case .searchNotStarted:
            tableView.isHidden = true
            mediaLibraryViewSpinner.isHidden = true
            mediaLibraryViewSpinner.stopAnimating()
            informatoryLabel.isHidden = false
            
        case .searchBegan:
            self.view.bringSubviewToFront(mediaLibraryViewSpinner)
            tableView.isHidden = true
            informatoryLabel.isHidden = true
            mediaLibraryViewSpinner.isHidden = false
            mediaLibraryViewSpinner.startAnimating()
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
        case .searchEndedWithResults:
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            mediaLibraryViewSpinner.stopAnimating()
            tableView.isHidden = false
            self.view.bringSubviewToFront(tableView)
            informatoryLabel.isHidden = true
            
        case .searchFailedWithoutResults:
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            mediaLibraryViewSpinner.stopAnimating()
            tableView.isHidden = true
            informatoryLabel.isHidden = false
            
        }
    }

}

extension NasaMediaLibraryViewController:UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("currentCount - \(String(describing: mediaLibraryListViewModel?.currentCount)) currentPage=\(String(describing: mediaLibraryListViewModel?.currentPage))")

        if (scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.height))
        {
            print("Can begin fetch")
            mediaLibraryListViewModel?.fetchMediaLibraryCollectionItems()
        }
    }
}

extension NasaMediaLibraryViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mediaLibraryListViewModel?.totalCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       if let cell = tableView.dequeueReusableCell(withIdentifier: identifiers.listCellIdentifier,
                                                   for: indexPath) as? NasaLibraryListTableViewCell{

            if isLoadingCell(for: indexPath) {
                cell.configure(with: .none)
            } else {
                cell.configure(with: mediaLibraryListViewModel?.nasaMediaLibraryModel(at: indexPath.row))
            }
        
            cell.selectionStyle = .none
            return cell
        }
        else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame:.zero)
    }
}
    


extension NasaMediaLibraryViewController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: identifiers.segueIdentifier, sender:tableView.cellForRow(at: indexPath))
    }
    
}

private extension NasaMediaLibraryViewController {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {

        if let viewModel = mediaLibraryListViewModel{
            return indexPath.row >= (viewModel.currentCount)
        }
        return false
    }

    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}


extension NasaMediaLibraryViewController:NasaLibraryListViewModelDelegate{
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        self.updateUI(for: .searchEndedWithResults)

        guard let newIndexPathsToReload = newIndexPathsToReload, let firstNewIndexPath = newIndexPathsToReload.first else {
            tableView.reloadData()
            return
        }

//        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
//        tableView.reloadRows(at: newIndexPathsToReload, with: .automatic)
        
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: newIndexPathsToReload, with:.fade)
        self.tableView.endUpdates()
        
        self.tableView.scrollToRow(at: firstNewIndexPath, at: .top, animated:true)
    }
    
    
    func onFetchFailed(with reason: String) {
        
        self.updateUI(for: .searchFailedWithoutResults)
        let title = "Failed to load the media"
        let action = UIAlertAction(title: "OK", style: .default)
        self.displayAlert(with: title , message: reason, actions: [action])
    }
}

extension NasaMediaLibraryViewController: UISearchBarDelegate {
    
    @objc func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        
        if let searchText = searchBar.text{
            self.updateUI(for: .searchBegan)
            let request = NasaMediaLibraryRequest.from(site:searchText)
            
            mediaLibraryListViewModel = NasaMediaLibraryViewModel(delegate:self, request: request)
            mediaLibraryListViewModel?.fetchMediaLibraryCollectionItems()
        }
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text, searchText.isEmpty{
            self.updateUI(for: .searchNotStarted)
            mediaLibraryListViewModel = nil
            tableView.reloadData()
        }
    }

}
