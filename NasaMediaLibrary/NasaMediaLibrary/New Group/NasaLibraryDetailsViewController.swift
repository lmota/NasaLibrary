//
//  NasaLibraryDetailsViewController.swift
//  NasaMediaLibrary
//
//  Created by Dharamshi, Lopa D on 4/4/19.
//  Copyright © 2019 Dharamshi Lopa D. All rights reserved.
//

import UIKit

class NasaLibraryDetailsViewController: UIViewController {
    
    var detailModel:NasaMediaLibraryCollectionItem?
    @IBOutlet weak var detailTableView: UITableView!
    
    private enum detailIdentifiers {
        static let CellIdentifier = "nasa library detail cell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setUpDetailView()
    }
    
    private func setUpDetailView(){
        
        self.navigationItem.title = "Nasa Image Details"
        self.detailTableView.dataSource = self
        self.detailTableView.reloadData()
    }

}

extension NasaLibraryDetailsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailModel?.mediaLibraryModels.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       if let cell = tableView.dequeueReusableCell(withIdentifier: detailIdentifiers.CellIdentifier,
                                                   for: indexPath) as? NasaLibraryDetailTableViewCell{
        
        
            cell.configure(with:detailModel)
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
 
}
