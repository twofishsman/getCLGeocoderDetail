//
//  ViewController.swift
//  getCLGeocoderDetail
//
//  Created by james on 17/12/2016.
//  Copyright © 2016 james. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet var labelCountry      : UILabel!
    @IBOutlet var labelProvince     : UILabel!
    @IBOutlet var labelLocality     : UILabel!
    @IBOutlet var labelSublocality  : UILabel!
    @IBOutlet var labelRoute        : UILabel!
    @IBOutlet var labelISOCode      : UILabel!
    @IBOutlet var labelPostalCode   : UILabel!
    @IBOutlet var textViewAll       : UITextView!
    @IBOutlet var langSegment       : UISegmentedControl!
    @IBOutlet var txtLatitude       : UITextField!
    @IBOutlet var txtLongitude      : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getGeoCoder(langCultureCode: "en_US")
        //getGeoCoder(langCultureCode: "zh_Hant_TW")
        //only first time, can be exchange the setting.
        //more info:http://stackoverflow.com/questions/4328839/looking-for-a-list-of-all-available-languages-in-ios
        //只有第一次設定AppleLanguages是生效的，之後的置換都無法修改到CLGeocoder功能
        //more info:http://stackoverflow.com/questions/4328839/looking-for-a-list-of-all-available-languages-in-ios
    }
    
     //sorry useless
    @IBAction func didTaplangSegment(sender : UISegmentedControl){
       
        if sender.selectedSegmentIndex == 0 {
            getGeoCoder(langCultureCode: "en_US")
        }else {
            getGeoCoder(langCultureCode: "zh_Hant_TW")
        }
    }
    
    func getGeoCoder(langCultureCode : String){
    
        var current = UserDefaults.standard.object(forKey: "AppleLanguages")
        print("old\(current)")
        UserDefaults.standard.set([langCultureCode], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        current = UserDefaults.standard.object(forKey: "AppleLanguages")
        print("new\(current)")
        
        self.reverseGeocodeLocation()
    }
    
    func reverseGeocodeLocation(){
        
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(CLLocation(latitude: CLLocationDegrees(Float(txtLatitude.text!)!),
                                                   longitude: CLLocationDegrees(Float(txtLongitude.text!)!)),
            completionHandler: {
                (placemarks,error) -> Void in
                
                if error != nil{
                    print("error:\(error)")
                    return
                }
                
                if placemarks != nil && (placemarks?.count)! > 0{
                    let placemark = (placemarks?[0])! as CLPlacemark
                    print(placemark)
      
                    self.labelISOCode.text      = ("ISOCode:\(placemark.isoCountryCode!)")
                    self.labelCountry?.text     = ("Country:\((placemark.country)!) \(placemark.country!.localizedCapitalized)")
                    self.labelProvince.text     = ("Province:\(placemark.subAdministrativeArea!) \(placemark.subAdministrativeArea!)")
                    self.labelLocality.text     = ("Locality:\(placemark.locality!) \(placemark.locality!)")
                    self.labelSublocality.text  = ("Sublocality:\(placemark.subLocality) \(placemark.subLocality)")
                    self.labelRoute.text        = ("Street:\(placemark.name!) \(placemark.name!)")
                    self.labelPostalCode.text   = ("Country:\(placemark.postalCode!) \(placemark.postalCode!)")
                    
                    let str = "raw:\(placemark)"
                    self.textViewAll.text = placemark.subAdministrativeArea! + str
                }
        })
    }
}

