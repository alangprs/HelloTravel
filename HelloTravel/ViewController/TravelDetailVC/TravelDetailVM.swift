//
//  TravelDetailVM.swift
//  HelloTravel
//
//  Created by cm0768 on 2023/4/11.
//

import Foundation

class TravelDetailVM {

    /// 顯示用資料
    private(set) var travelItem: DisplayBusiness?

    init(travelItem: DisplayBusiness) {
        self.travelItem = travelItem
    }

    func getBusinessItem() -> DisplayBusiness? {
        return travelItem
    }
}
