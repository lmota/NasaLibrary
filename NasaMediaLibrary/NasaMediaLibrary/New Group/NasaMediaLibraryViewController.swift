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
    
    private var mediaLibraryListViewModel:NasaMediaLibraryViewModel?
    
    private enum CellIdentifiers {
        static let list = "nasa library list cell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    private func setUpView(){

        tableView.isHidden = true
        mediaLibraryViewSpinner.isHidden = true
        mediaLibraryViewSpinner.stopAnimating()
        self.navigationItem.title = "Search Nasa Media Library"
        tableView.separatorColor = .gray
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
//        tableView.register(NasaLibraryListTableViewCell.self, forCellReuseIdentifier: CellIdentifiers.list)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier{
        case "show nasa image details":
            if let detailViewController = segue.destination as? NasaLibraryDetailsViewController, let selectedCell = sender as? NasaLibraryListTableViewCell, let selectedIndexPath = tableView.indexPath(for: selectedCell) {
                detailViewController.detailModel = mediaLibraryListViewModel?.nasaMediaLibraryModel(at: selectedIndexPath.row)

            }
        default: break
        }
    }

}

extension NasaMediaLibraryViewController:UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.list,
                                                 for: indexPath) as! NasaLibraryListTableViewCell

        if isLoadingCell(for: indexPath) {
            cell.configure(with: .none)
        } else {
            cell.configure(with: mediaLibraryListViewModel?.nasaMediaLibraryModel(at: indexPath.row))
        }
        
        cell.selectionStyle = .none
        return cell
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
        performSegue(withIdentifier: "show nasa image details", sender:tableView.cellForRow(at: indexPath))
    }
    
}

//extension NasaMediaLibraryViewController:UITableViewDataSourcePrefetching{
//    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
//         if indexPaths.contains(where: isLoadingCell) {
//            print("fetching request for next pages")
//            mediaLibraryListViewModel?.fetchMediaLibraryCollectionItems()
//        }
//    }
//
//
//}

private extension NasaMediaLibraryViewController {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {

        if let viewModel = mediaLibraryListViewModel{
            print("indexPath-\(indexPath.row) currentCount - \(viewModel.currentCount)")
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
        // 1
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        mediaLibraryViewSpinner.stopAnimating()

        guard let newIndexPathsToReload = newIndexPathsToReload, let firstNewIndexPath = newIndexPathsToReload.first else {
            tableView.isHidden = false
            self.view.bringSubviewToFront(tableView)
            tableView.reloadData()
            return
        }
        
        tableView.isHidden = false
        self.view.bringSubviewToFront(tableView)
        
//        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
//        tableView.reloadRows(at: newIndexPathsToReload, with: .automatic)
        
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: newIndexPathsToReload, with:.fade)
        self.tableView.endUpdates()
        
        self.tableView.scrollToRow(at: firstNewIndexPath, at: .top, animated:true)
    }
    
    
    func onFetchFailed(with reason: String) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        mediaLibraryViewSpinner.stopAnimating()
        
        let title = "failed to load the media"
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
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        if let searchText = searchBar.text{
            
            self.view.bringSubviewToFront(mediaLibraryViewSpinner)
            tableView.isHidden = true
            informatoryLabel.isHidden = true
            mediaLibraryViewSpinner.isHidden = false
            mediaLibraryViewSpinner.startAnimating()

            let request = NasaMediaLibraryRequest.from(site:searchText) // parameter needs to be replaced by search text input
            
            mediaLibraryListViewModel = NasaMediaLibraryViewModel(delegate:self, request: request)
            mediaLibraryListViewModel?.fetchMediaLibraryCollectionItems()
        }
        
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {

    }
 
}

