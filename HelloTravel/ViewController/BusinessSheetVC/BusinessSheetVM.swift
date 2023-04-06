//
//  BusinessSheetVM.swift
//  HelloTravel
//
//  Created by 翁燮羽 on 2023/4/1.
//

import Foundation

class BusinessSheetVM {
    
    private(set) lazy var travelList: [DisplayBusiness] = {
        return [DisplayBusiness]()
    }()
    
    func getTravelItem(indexPath: IndexPath) -> DisplayBusiness? {
        if travelList.indices.contains(indexPath.row) {
            return travelList[indexPath.row]
        } else {
            return nil
        }
    }
    
    func fetchSearchResults(travelList: [DisplayBusiness]) {
        self.travelList = travelList
    }
}
