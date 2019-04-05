//
//  NasaLibraryDetailsViewController.swift
//  NasaMediaLibrary
//
//  Created by Dharamshi, Lopa D on 4/4/19.
//  Copyright © 2019 Dharamshi Lopa D. All rights reserved.
//

import UIKit

class NasaLibraryDetailsViewController: UIViewController {
    
    @IBOutlet weak var detailTableView: UITableView!
    var mediaLibraryDetailViewModel:NasaMediaLibraryDetailViewModel?
    
    private enum detailIdentifiers {
        static let CellIdentifier = "nasa library detail cell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setUpDetailView()
    }
    
    private func setUpDetailView(){
        
        self.navigationItem.title = "Nasa Image Details".localizedCapitalized
        self.detailTableView.dataSource = self
        self.detailTableView.reloadData()
        self.view.backgroundColor = Constants.backgroundColor
        detailTableView.backgroundColor = .clear

    }

}

extension NasaLibraryDetailsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mediaLibraryDetailViewModel?.detailViewRowCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       if let cell = tableView.dequeueReusableCell(withIdentifier: detailIdentifiers.CellIdentifier,
                                                   for: indexPath) as? NasaLibraryDetailTableViewCell{
        
            cell.configure(with:mediaLibraryDetailViewModel)
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
 
}
