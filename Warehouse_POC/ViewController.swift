//
//  ViewController.swift
//  Warehouse_POC
//
//  Created by Incture on 16/02/23.
//

import UIKit
import ArcGIS
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var mapview: AGSMapView!
    let locator = AGSLocatorTask(url: URL(string: "https://geocode-api.arcgis.com/arcgis/rest/services/world/GeocodeServer")!)
    
    let locatorResults = AGSGraphicsOverlay()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        AGSArcGISRuntimeEnvironment.apiKey = "AAPK9b2d2da0acbd440bb02498984778efacgpemjl0-kYaG2JTy52C6cSZYCAyczeRKUIaFnjBNfIEm0ggqp9kEwhE8ye9u1Q4Q"
        let map = AGSMap(basemapStyle: .arcGISNavigation)
        mapview.map = map
        mapview.setViewpoint(AGSViewpoint(latitude: 33.82496, longitude: -116.53862, scale: 18055.954822))
        mapview.graphicsOverlays.add(locatorResults)
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        locator.geocode(withSearchText: searchText) { [weak self] (results, error) in
            guard let self = self else { return }
            if let error = error {
                print("Geocoding failed: \(error.localizedDescription)")
                return
            }
            
            guard let result = results?.first else { return }
            if let extent = result.extent {
                self.mapview.setViewpointGeometry(extent, completion: nil)
            }
            let resultGraphic = AGSGraphic(geometry: result.displayLocation, symbol: AGSSimpleMarkerSymbol(style: .circle, color: .red, size: 15),
            attributes: nil)
            self.locatorResults.graphics.add(resultGraphic)
    
            }
        }
    }
    

