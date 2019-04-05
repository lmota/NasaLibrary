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
    
    // setting up the view
    private func setUpView(){

        self.updateUI(for: .searchNotStarted)
        self.navigationItem.title = "Search Nasa Media Library".localizedCapitalized
        tableView.separatorColor = .gray
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        informatoryLabel.text = "Please begin your search by entering the search text in the search bar".localizedCapitalized
        searchBar.placeholder = "Enter the nasa library search text".localizedCapitalized
        self.view.backgroundColor = Constants.backgroundColor
        tableView.backgroundColor = .clear
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // populating the details view controller with the view model and view model with the item at the selected row
        switch segue.identifier{
        case identifiers.segueIdentifier:
            if let detailViewController = segue.destination as? NasaLibraryDetailsViewController, let selectedCell = sender as? NasaLibraryListTableViewCell, let selectedIndexPath = tableView.indexPath(for: selectedCell), let detailModel = mediaLibraryListViewModel?.nasaMediaLibraryModel(at: selectedIndexPath.row) {                
                detailViewController.mediaLibraryDetailViewModel = NasaMediaLibraryDetailViewModel(detailModel: detailModel)

            }
        default: break
        }
    }
    
    /**
     * function that updates the various ui elements on the screen based on its state
     */
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

/**
 * scroll view delegate
 */
extension NasaMediaLibraryViewController:UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        /**
         * Need to determine if user has scrolled to the bottom of the table, if yes, we fetch the additional pages from server
         * this will implement the infinite scrolling behaviour for the tableview pagination.
         */
        if (scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.height))
        {
            Logger.logInfo("Can begin fetching media if max page limit is not reached")
            mediaLibraryListViewModel?.fetchMediaLibraryCollectionItems()
        }
    }
}

/**
 * table view data source delegates
 */
extension NasaMediaLibraryViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mediaLibraryListViewModel?.totalCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       if let cell = tableView.dequeueReusableCell(withIdentifier: identifiers.listCellIdentifier,
                                                   for: indexPath) as? NasaLibraryListTableViewCell{

            if isLoadingCell(for: indexPath) {
                cell.configure(at: indexPath.row, viewModel:.none)
            } else {
                cell.configure(at: indexPath.row, viewModel: mediaLibraryListViewModel)
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
    

/**
 *  UITableViewDelegate implementation
 */
extension NasaMediaLibraryViewController:UITableViewDelegate{
    // on did select, navigate user to the details of that item
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: identifiers.segueIdentifier, sender:tableView.cellForRow(at: indexPath))
    }
    
}

private extension NasaMediaLibraryViewController {
    // determine if the loading cell needs to appear
    func isLoadingCell(for indexPath: IndexPath) -> Bool {

        if let viewModel = mediaLibraryListViewModel{
            return indexPath.row >= (viewModel.currentCount)
        }
        return false
    }
}

// view model delegates once the fetching of the media is completed
extension NasaMediaLibraryViewController:NasaLibraryListViewModelDelegate{
    
    //  on success case of the fetch completion
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        self.updateUI(for: .searchEndedWithResults)

        guard let newIndexPathsToReload = newIndexPathsToReload, let firstNewIndexPath = newIndexPathsToReload.first else {
            tableView.reloadData()
            return
        }
        
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: newIndexPathsToReload, with:.fade)
        self.tableView.endUpdates()
        
        self.tableView.scrollToRow(at: firstNewIndexPath, at: .top, animated:true)
    }
    
    // on the failure case of fetch completion
    func onFetchFailed(with reason: String) {
        
        self.updateUI(for: .searchFailedWithoutResults)
        let title = "Failed to load the media".localizedCapitalized
        let action = UIAlertAction(title: "OK".localizedUppercase, style: .default)
        self.displayAlert(with: title , message: reason, actions: [action])
    }
}

// searhBar delegate methods.
extension NasaMediaLibraryViewController: UISearchBarDelegate {
    
    @objc func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    // when the search is clicked, initialize the viewmodel and fetch the media items from server.
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
    
    // need to ensure that if user cleared the search then we update the ui back to its initial search not started state
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text, searchText.isEmpty{
            self.updateUI(for: .searchNotStarted)
            mediaLibraryListViewModel = nil
            tableView.reloadData()
        }
    }

}
