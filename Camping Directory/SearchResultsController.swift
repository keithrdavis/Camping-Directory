//
//  SearchResultsController.swift
//  Camping Directory
//
//  Created by Keith Davis on 9/18/16.
//  Copyright © 2016 ZuniSoft. All rights reserved.
//

import UIKit
import Alamofire
import SWXMLHash

class SearchResultsController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
   
    var sequeUrl : String?
    var data:[Data.SearchResult] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        loadData(url: sequeUrl!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData(url : String) {
        
        Alamofire.request(url).responseString { response in
            switch response.result {
                case .success:
                    let xml = SWXMLHash.parse(response.result.value!)
                    
                    for index in 1...xml["resultset"].children.count - 1 {
                        for elem in xml["resultset"] {
                            let state = elem["result"][index].element?.attribute(by: "state")?.text
                            
                            let fname = elem["result"][index].element?.attribute(by: "facilityName")?.text
                            
                            let fid = elem["result"][index].element?.attribute(by: "facilityID")?.text
                            
                            let lat = elem["result"][index].element?.attribute(by: "latitude")?.text
                            
                            let long = elem["result"][index].element?.attribute(by: "longitude")?.text
                            
                            var result: Data.SearchResult! = Data.SearchResult()
                            
                            result.state = state!
                            result.facilityName = fname!
                            result.facilityId = fid!
                            result.latitude = lat!
                            result.longitude = long!
                            
                            self.data.append(result)
                        }
                    }
                    
                    // Load the tableview
                    self.tableView.reloadData()
                case .failure(let error):
                    self.alert(message: error.localizedDescription)
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell;
        */
        
        let cell:SearchResultCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SearchResultCell
        
        let result = self.data[indexPath.row]
        
        cell.FacilityName?.text = result.facilityName;
        cell.FacilityId?.text = result.facilityId;
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Create a new variable to store the instance of DetailController
        let destinationVC = segue.destination as! DetailController
        let selectedRow = tableView.indexPathForSelectedRow!.row
        
        var sequeData = Data.SearchResult()
        
        sequeData.state = data[selectedRow].state
        sequeData.facilityId = data[selectedRow].facilityId
        sequeData.facilityName = data[selectedRow].facilityName
        sequeData.latitude = data[selectedRow].latitude
        sequeData.longitude = data[selectedRow].longitude
        
        destinationVC.sequeData = sequeData
    }
}
 

