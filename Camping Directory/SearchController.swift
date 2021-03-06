//
//  SearchController.swift
//  Camping Directory
//
//  This program is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 2
//  of the License, or (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program; if not, write to the Free Software
//  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
//
//  Created by Keith Davis on 9/21/16.
//  Copyright © 2016 ZuniSoft. All rights reserved.
//

import UIKit

class SearchController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIScrollViewDelegate, UITextFieldDelegate {
    
    var pickerDataSource: [String] = Constants.stateList
    var statePickerValue: String = ""
    
    
    @IBOutlet weak var optionScroll: UIScrollView!
    @IBOutlet weak var viewScroll: UIView!
    @IBOutlet weak var statePicker: UIPickerView!
    @IBOutlet weak var maxPeopleField: UITextField!
    @IBOutlet weak var cgNameField: UITextField!
    @IBOutlet weak var rvLengthField: UITextField!
    @IBOutlet weak var petsAllowedSwitch: UISwitch!
    @IBOutlet weak var waterSwitch: UISwitch!
    @IBOutlet weak var sewerSwitch: UISwitch!
    @IBOutlet weak var pullThroughSwitch: UISwitch!
    @IBOutlet weak var waterFrontSwitch: UISwitch!
    @IBOutlet weak var ampsAvailableSegment: UISegmentedControl!
    @IBOutlet weak var facilityTypeSegment: UISegmentedControl!
    @IBOutlet weak var aboutButton: UIBarButtonItem!
    @IBOutlet weak var searchButton: UIButton!
    
    // About Button
    @IBAction func aboutButtonClicked(_ sender: UIBarButtonItem) {
        let alertMessage = UIAlertController(title: "Camping Directory", message: "", preferredStyle: .alert)
        
        // Application Icon
        let image = UIImage(named: "AppIcon40x40")
        
        let imageView = UIImageView(frame: CGRect(x: 115, y: 48, width: 40, height: 40))
        imageView.image = image
        imageView.layer.cornerRadius = 8.0
        imageView.clipsToBounds = true
        
        alertMessage.view.addSubview(imageView)
        
        // Application Version
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        
        // Description
        var message = "\n\n\nVersion " + version! + "\n\n"
        message += "This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License version 2 as published by the Free Software Foundation.\n\nGitHub:  https://github.com/keithrdavis/Camping-Directory\n\nCopyright © 2016 Keith R. Davis"
        
        alertMessage.message = message
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertMessage .addAction(action)
        
        self.present(alertMessage, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Connect data:
        self.statePicker.dataSource = self;
        self.statePicker.delegate = self;
        
        self.optionScroll.delegate = self;
        
        self.rvLengthField.delegate = self;
        
        self.maxPeopleField.delegate = self;
        
        // Defaults
        self.statePicker.selectRow(0, inComponent: 0, animated: true)
        statePickerValue = Constants.stateDictionary[Constants.stateList[statePicker.selectedRow(inComponent: 0)]]!
        
        self.searchButton.layer.cornerRadius = 5
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // The number of columns of data.
    func numberOfComponents(in statePicker: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data.
    func pickerView(_ statePicker: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count
    }
    
    // The data to return for the row and component (column) that's being passed in.
    func pickerView(_ statePicker: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row]
    }
    
    // The row selected in the picker by the user.
    func pickerView(_ statePicker: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        statePickerValue = Constants.stateDictionary[Constants.stateList[row]]!
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
        return string.rangeOfCharacter(from: invalidCharacters, options: [], range: string.startIndex ..< string.endIndex) == nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Create a variable that you want to send
        var newSequeUrl : String
        
        // API url
        newSequeUrl = Constants.svcCampgroundURL
        
        // API key
        newSequeUrl += "?api_key=" + Constants.svcCampgroundAPIKey
        
        // State
        newSequeUrl += "&pstate=" + statePickerValue
        
        // CG name
        let cgNameValue = cgNameField.text == "" ? "" : cgNameField.text
        if cgNameValue != "" {
            newSequeUrl += "&pname=" + cgNameValue!
        }
        
        // RV length
        let rvLengthValue = rvLengthField.text == "" ? "" : rvLengthField.text
        if rvLengthValue != "" {
            newSequeUrl += "&eqplen=" + rvLengthValue!
        }

        // Facility type
        var facilityTypeValue: String?
        let facilityTypeSelected = facilityTypeSegment.selectedSegmentIndex
        
        switch facilityTypeSelected {
        case 0:
            facilityTypeValue = ""
        case 1:
            facilityTypeValue = "2001"
        case 2:
            facilityTypeValue = "10001"
        case 3:
            facilityTypeValue = "2003"
        case 4:
            facilityTypeValue = "2002"
        case 5:
            facilityTypeValue = "9002"
        case 6:
            facilityTypeValue = "9001"
        case 7:
            facilityTypeValue = "3001"
        case 8:
            facilityTypeValue = "2004"
        default: break
        }
        
        if (facilityTypeValue != "") {
            newSequeUrl += "&siteType=" + facilityTypeValue!
        }
        
        // Max people
        let maxPeopleValue = maxPeopleField.text == "" ? "" : maxPeopleField.text
        if maxPeopleValue != "" {
            newSequeUrl += "&Maxpeople=" + maxPeopleValue!
        }
        
        // Water
        let waterValue = waterSwitch.isOn ? 3007 : 0
        if waterValue == 3007 {
            newSequeUrl += "&water=" + String(waterValue)
        }
        
        // Sewer
        let sewerValue = sewerSwitch.isOn ? 3007 : 0
        if sewerValue == 3007 {
            newSequeUrl += "&sewer=" + String(sewerValue)
        }
        
        // Pets allowed
        let petsAllowedValue = petsAllowedSwitch.isOn ? 3010 : 0
        if petsAllowedValue == 3010 {
            newSequeUrl += "&pets=" + String(petsAllowedValue)
        }
        
        //  Pull through
        let pullThroughValue = pullThroughSwitch.isOn ? 3008 : 0
        if pullThroughValue == 3008 {
            newSequeUrl += "&pull=" + String(pullThroughValue)
        }
        
        //  Waterfront
        let waterFrontValue = waterFrontSwitch.isOn ? 3011 : 0
        if waterFrontValue == 3011 {
            newSequeUrl += "&waterfront=" + String(waterFrontValue)
        }
        
        // Power
        var powerValue: String?
        let powerSelected = ampsAvailableSegment.selectedSegmentIndex
        
        switch powerSelected {
        case 0:
            powerValue = ""
        case 1:
            powerValue = "3002"
        case 2:
            powerValue = "3003"
        case 3:
            powerValue = "3004"
        case 4:
            powerValue = "3005"
        default: break
        }
        
        if (powerValue != "") {
            newSequeUrl += "&hookup=" + powerValue!
        }
        
        debugPrint("URL: " + newSequeUrl)
        
        // Create a new variable to store the instance of SearchResultsViewController
        let destinationVC = segue.destination as! SearchResultsController
        destinationVC.sequeUrl = newSequeUrl.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
    }
}
