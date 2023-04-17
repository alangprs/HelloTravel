//
//  NearbyLandmarkVM.swift
//  HelloTravel
//
//  Created by cm0768 on 2023/3/17.
//

import UIKit

protocol NearbyLandmarkVMDelegate: AnyObject {
    func noGPSPermission()
    func getTravelItemSuccess()
    func getTravelItemError()
}

class NearbyLandmarkVM {

    weak var delegate: NearbyLandmarkVMDelegate?

    private lazy var locationManager: LocationManager = {
        var locationManager = LocationManager.shared
        locationManager.delegate = self
        return locationManager
    }()

    /// 資料庫
    private lazy var realtimeDatabaseAdapter: RealtimeDatabaseAdapter = {
        return RealtimeDatabaseAdapter()
    }()

    /// 顯示用資料
    private(set) var travelList: [DisplayBusiness] = []
    /// api 原始資料
    private var apiDataList: [Business] = []
    /// 收藏清單資料
    private var likeList: [LikeListStructValue] = []
    /// 取附近資料
    private var searchBusinessesUseCase: SearchBusinessesUseCase?
    
    /// 詢問定位權限
    func askPermission() {
        locationManager.askPermission()
    }

    func getTravelItem(indexPath: IndexPath) -> DisplayBusiness? {
        if travelList.indices.contains(indexPath.row) {
            return travelList[indexPath.row]
        } else {
            Logger.errorLog(message: "travelList is out range")
            return nil
        }
    }

    /// 計算要顯示的星星圖片
    /// - Parameter starsCount: 星星數量
    /// - Returns: 星星圖片
    func calculateStarIcon(starsCount: Double) -> UIImage {
        var image = UIImage()
        switch starsCount {
            
        case 1...1.9:
            image = UIImage(named: "star1") ?? UIImage()
        case 2...2.9:
            image = UIImage(named: "star2") ?? UIImage()
        case 3...3.9:
            image = UIImage(named: "star3") ?? UIImage()
        case 4...4.9:
            image = UIImage(named: "star4") ?? UIImage()
        case 5:
            image = UIImage(named: "star5") ?? UIImage()
        default:
            image = UIImage(named: "star0") ?? UIImage()
            return image
        }
        
        return image
    }

    /// 取得周圍景點
    private func getNearbyAttractions() {

        searchBusinessesUseCase?.getBusinessesData { [weak self] result in
            guard let self = self else { return }

            switch result {
                case .success(let item):
                    self.apiDataList = item.businesses
                case .failure(let error):
                    Logger.errorLog(message: error)
                    self.delegate?.getTravelItemError()
            }
        }
    }

    /// 將api取得原始資料複製一份到顯示用資料
    private func mappingTravelKist() {

        travelList.removeAll()

        for indexItem in apiDataList {

            let isFavorite = getIsFavorite(id: indexItem.id)

            let likeData: DisplayBusiness = .init(id: indexItem.id,
                                                  alias: indexItem.alias,
                                                  name: indexItem.name,
                                                  imageURL: indexItem.imageURL,
                                                  isClosed: indexItem.isClosed,
                                                  url: indexItem.url,
                                                  reviewCount: indexItem.reviewCount,
                                                  categories: indexItem.categories,
                                                  rating: indexItem.rating,
                                                  coordinates: indexItem.coordinates,
                                                  location: indexItem.location,
                                                  phone: indexItem.phone,
                                                  displayPhone: indexItem.displayPhone,
                                                  distance: indexItem.distance,
                                                  price: indexItem.price,
                                                  isFavorites: isFavorite)
            travelList.append(likeData)
        }
    }


    // MARK: - 收藏清單區域

    func removeAllObservers() {
        realtimeDatabaseAdapter.removeAllObservers()
    }

    /// 判斷是否在收藏清單內
    private func getIsFavorite(id: String) -> Bool {
        guard !likeList.isEmpty else { return false }

        for like in likeList {
            if like.id == id {
                return true
            }
        }
        return false
    }

    /// 即時取得 database 資料
    private func referenceData() {
        realtimeDatabaseAdapter.referenceData { [weak self] result in

            guard let self = self else { return }

            switch result {
                case .success(let success):
                    self.likeList = success
                    self.mappingTravelKist()
                    self.delegate?.getTravelItemSuccess()
                case .failure(let failure):
                    Logger.errorLog(message: failure)
            }
        }
    }

    /// 判斷是新增 or 取消 收藏
    /// - Parameter tag: 點選到的 button tag
    func toggleLikeStatus(tag: Int) {

        guard travelList.indices.contains(tag) else { return }

        if travelList[tag].isFavorites {
            removeLikeItem(tag: tag)
        } else {
            postLikeListData(tag: tag)
        }
    }

    /// 上傳收藏資料
    private func postLikeListData(tag: Int) {

        guard travelList.indices.contains(tag) else { return }

        let placeItem = travelList[tag]
        
        do {
            let data = try JSONEncoder().encode(placeItem)
            realtimeDatabaseAdapter.postLiktListData(nodeID: placeItem.id, data: data)
            delegate?.getTravelItemSuccess()
        } catch {
            Logger.log(message: "encoder likeList to date error")
        }
    }

    /// 移除指定收藏資料
    private func removeLikeItem(tag: Int) {
        guard travelList.indices.contains(tag) else { return }

        let placeItem = travelList[tag]
        realtimeDatabaseAdapter.removeLikeListValue(nodeID: placeItem.id)
    }

}

// MARK: - 定位

extension NearbyLandmarkVM: LocationManagerDelegate {
    func sandLocation(latitude: Double, longitude: Double) {

        // TODO: - 先寫死在新加坡，不然台灣東西太少
        searchBusinessesUseCase = SearchBusinessesUseCase(latitude: 1.284066, longitude: 103.841114)

        // 取收藏、景點資料
        //            getNearbyAttractions()
        decodeJson()
        referenceData()
    }

    func noGPSPermission() {
        delegate?.noGPSPermission()
        Logger.log(message: "clickDenied")
    }
}


// MARK: - 測試用
extension NearbyLandmarkVM {

    /// 模擬打api
    private func decodeJson() {
        let jsonStr = testJson()

        if let data = jsonStr.data(using: .utf8) {
            do {
                let jsonitem = try JSONDecoder().decode(SearchBusinessesStruct.self, from: data)
                apiDataList = jsonitem.businesses
            } catch {
                Logger.errorLog(message: "get decode error")
            }
        }

    }

    private func testJson() -> String {
        let json = """
    {
      "businesses": [
        {
          "id": "wcYmWVGB0kVdjfp3kmovkA",
          "alias": "zhong-guo-la-mian-xiao-long-bao-singapore",
          "name": "Zhong Guo La Mian Xiao Long Bao",
          "image_url": "https://s3-media3.fl.yelpcdn.com/bphoto/a5bAZQp1FCY6qseBi0d1tA/o.jpg",
          "is_closed": false,
          "url": "https://www.yelp.com/biz/zhong-guo-la-mian-xiao-long-bao-singapore?adjust_creative=L2DNe2W3HxwxlaFN2D-DJg&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=L2DNe2W3HxwxlaFN2D-DJg",
          "review_count": 34,
          "categories": [
            {
              "alias": "shanghainese",
              "title": "Shanghainese"
            },
            {
              "alias": "dimsum",
              "title": "Dim Sum"
            },
            {
              "alias": "noodles",
              "title": "Noodles"
            }
          ],
          "rating": 4.5,
          "coordinates": {
            "latitude": 1.28218,
            "longitude": 103.84317
          },
          "transactions": [],
          "price": "$",
          "location": {
            "address1": "Blk 335 Smith St",
            "address2": "#02-135",
            "address3": "",
            "city": "Singapore",
            "zip_code": "051335",
            "country": "SG",
            "state": "SG",
            "display_address": [
              "Blk 335 Smith St",
              "#02-135",
              "Singapore 051335",
              "Singapore"
            ]
          },
          "phone": "",
          "display_phone": "",
          "distance": 274.70245388990696
        },
        {
          "id": "KQWVZpMJbWXkVOUuKX56kw",
          "alias": "the-butchers-wife-singapore",
          "name": "The Butcher's Wife",
          "image_url": "https://s3-media1.fl.yelpcdn.com/bphoto/LnKKyxbUPNeZ_H-aP5B_mw/o.jpg",
          "is_closed": false,
          "url": "https://www.yelp.com/biz/the-butchers-wife-singapore?adjust_creative=L2DNe2W3HxwxlaFN2D-DJg&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=L2DNe2W3HxwxlaFN2D-DJg",
          "review_count": 6,
          "categories": [
            {
              "alias": "gluten_free",
              "title": "Gluten-Free"
            }
          ],
          "rating": 5,
          "coordinates": {
            "latitude": 1.28276221542869,
            "longitude": 103.830182477832
          },
          "transactions": [],
          "location": {
            "address1": "19 Yong Siak St",
            "address2": "",
            "address3": null,
            "city": "Singapore",
            "zip_code": "168650",
            "country": "SG",
            "state": "SG",
            "display_address": [
              "19 Yong Siak St",
              "Singapore 168650",
              "Singapore"
            ]
          },
          "phone": "+6562219307",
          "display_phone": "+65 6221 9307",
          "distance": 1224.3664563286716
        },
        {
          "id": "2_58nq4WJQbe5Qy3W-dK0w",
          "alias": "old-chengdu-sichuan-cuisine-singapore",
          "name": "Old Chengdu Sichuan Cuisine",
          "image_url": "https://s3-media2.fl.yelpcdn.com/bphoto/jckR3dt1BIjKTjTdd4DtxQ/o.jpg",
          "is_closed": false,
          "url": "https://www.yelp.com/biz/old-chengdu-sichuan-cuisine-singapore?adjust_creative=L2DNe2W3HxwxlaFN2D-DJg&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=L2DNe2W3HxwxlaFN2D-DJg",
          "review_count": 13,
          "categories": [
            {
              "alias": "szechuan",
              "title": "Szechuan"
            },
            {
              "alias": "importedfood",
              "title": "Imported Food"
            }
          ],
          "rating": 4,
          "coordinates": {
            "latitude": 1.28379,
            "longitude": 103.84365
          },
          "transactions": [],
          "price": "$$",
          "location": {
            "address1": "80/82 Pagoda St",
            "address2": "",
            "address3": "",
            "city": "Singapore",
            "zip_code": "059239",
            "country": "SG",
            "state": "SG",
            "display_address": [
              "80/82 Pagoda St",
              "Singapore 059239",
              "Singapore"
            ]
          },
          "phone": "+6562226858",
          "display_phone": "+65 6222 6858",
          "distance": 282.6729190459916
        },
        {
          "id": "bkj4QMOWfQB2z0znv0PKPQ",
          "alias": "song-fa-bak-kut-teh-singapore-6",
          "name": "Song Fa Bak Kut Teh",
          "image_url": "https://s3-media2.fl.yelpcdn.com/bphoto/w0E6t9U-GJNkWSBZnWl_8g/o.jpg",
          "is_closed": false,
          "url": "https://www.yelp.com/biz/song-fa-bak-kut-teh-singapore-6?adjust_creative=L2DNe2W3HxwxlaFN2D-DJg&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=L2DNe2W3HxwxlaFN2D-DJg",
          "review_count": 41,
          "categories": [
            {
              "alias": "chinese",
              "title": "Chinese"
            },
            {
              "alias": "singaporean",
              "title": "Singaporean"
            }
          ],
          "rating": 4.5,
          "coordinates": {
            "latitude": 1.28509935709304,
            "longitude": 103.844663791402
          },
          "transactions": [],
          "price": "$",
          "location": {
            "address1": "133 New Bridge Rd",
            "address2": "#01-04",
            "address3": "",
            "city": "Singapore",
            "zip_code": "059413",
            "country": "SG",
            "state": "SG",
            "display_address": [
              "133 New Bridge Rd",
              "#01-04",
              "Singapore 059413",
              "Singapore"
            ]
          },
          "phone": "+6564431033",
          "display_phone": "+65 6443 1033",
          "distance": 410.388571364013
        },
        {
          "id": "YiwgRnxp091jA6z98a71GQ",
          "alias": "binomio-singapore-2",
          "name": "Binomio",
          "image_url": "https://s3-media2.fl.yelpcdn.com/bphoto/Rf48Eq0S3smwfbDPPiTeAQ/o.jpg",
          "is_closed": false,
          "url": "https://www.yelp.com/biz/binomio-singapore-2?adjust_creative=L2DNe2W3HxwxlaFN2D-DJg&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=L2DNe2W3HxwxlaFN2D-DJg",
          "review_count": 15,
          "categories": [
            {
              "alias": "spanish",
              "title": "Spanish"
            },
            {
              "alias": "tapasmallplates",
              "title": "Tapas/Small Plates"
            }
          ],
          "rating": 4.5,
          "coordinates": {
            "latitude": 1.27766649229806,
            "longitude": 103.842091814591
          },
          "transactions": [],
          "price": "$$$",
          "location": {
            "address1": "Craig Place",
            "address2": "20 Craig Road",
            "address3": "#01-02",
            "city": "Singapore",
            "zip_code": "089692",
            "country": "SG",
            "state": "SG",
            "display_address": [
              "Craig Place",
              "20 Craig Road",
              "#01-02",
              "Singapore 089692",
              "Singapore"
            ]
          },
          "phone": "+6565570547",
          "display_phone": "+65 6557 0547",
          "distance": 720.4433372541141
        },
        {
          "id": "3hxwHzQ432UL3rQAWJG5TA",
          "alias": "hokkaido-ramen-santouka-singapore",
          "name": "Hokkaido Ramen Santouka",
          "image_url": "https://s3-media2.fl.yelpcdn.com/bphoto/nMuAydsvAoQHqP3Cn1K5NA/o.jpg",
          "is_closed": false,
          "url": "https://www.yelp.com/biz/hokkaido-ramen-santouka-singapore?adjust_creative=L2DNe2W3HxwxlaFN2D-DJg&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=L2DNe2W3HxwxlaFN2D-DJg",
          "review_count": 59,
          "categories": [
            {
              "alias": "ramen",
              "title": "Ramen"
            }
          ],
          "rating": 4.5,
          "coordinates": {
            "latitude": 1.28796305006824,
            "longitude": 103.846003923218
          },
          "transactions": [],
          "price": "$$",
          "location": {
            "address1": "6 Eu Tong Sen St",
            "address2": "#02-76",
            "address3": "",
            "city": "Singapore",
            "zip_code": "059817",
            "country": "SG",
            "state": "SG",
            "display_address": [
              "6 Eu Tong Sen St",
              "#02-76",
              "Singapore 059817",
              "Singapore"
            ]
          },
          "phone": "+6562240668",
          "display_phone": "+65 6224 0668",
          "distance": 694.4089762230219
        },
        {
          "id": "pzCmmOFGWCsiPPHadYLRMA",
          "alias": "jumbo-singapore",
          "name": "Jumbo",
          "image_url": "https://s3-media2.fl.yelpcdn.com/bphoto/7mQnIe-SfsdnHwIaYcikFw/o.jpg",
          "is_closed": false,
          "url": "https://www.yelp.com/biz/jumbo-singapore?adjust_creative=L2DNe2W3HxwxlaFN2D-DJg&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=L2DNe2W3HxwxlaFN2D-DJg",
          "review_count": 8,
          "categories": [
            {
              "alias": "seafood",
              "title": "Seafood"
            },
            {
              "alias": "singaporean",
              "title": "Singaporean"
            }
          ],
          "rating": 4.5,
          "coordinates": {
            "latitude": 1.30408,
            "longitude": 103.83181
          },
          "transactions": [],
          "location": {
            "address1": "2 Orchard Turn",
            "address2": "#04-09/10",
            "address3": null,
            "city": "Singapore",
            "zip_code": "238801",
            "country": "SG",
            "state": "SG",
            "display_address": [
              "2 Orchard Turn",
              "#04-09/10",
              "Singapore 238801",
              "Singapore"
            ]
          },
          "phone": "+6567373735",
          "display_phone": "+65 6737 3735",
          "distance": 2432.784029692308
        },
        {
          "id": "5clWua4HzuSaulRL82DBkA",
          "alias": "kafe-utu-no-title",
          "name": "Kafe Utu",
          "image_url": "https://s3-media3.fl.yelpcdn.com/bphoto/9vpc0nDl8BoppUIGV3OEIQ/o.jpg",
          "is_closed": false,
          "url": "https://www.yelp.com/biz/kafe-utu-no-title?adjust_creative=L2DNe2W3HxwxlaFN2D-DJg&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=L2DNe2W3HxwxlaFN2D-DJg",
          "review_count": 4,
          "categories": [
            {
              "alias": "cafes",
              "title": "Cafes"
            }
          ],
          "rating": 5,
          "coordinates": {
            "latitude": 1.2798,
            "longitude": 103.84191
          },
          "transactions": [],
          "location": {
            "address1": "12 Jiak Chuan Road",
            "address2": null,
            "address3": "",
            "city": "Singapore",
            "zip_code": "089265",
            "country": "SG",
            "state": "SG",
            "display_address": [
              "12 Jiak Chuan Road",
              "Singapore 089265",
              "Singapore"
            ]
          },
          "phone": "+6569963937",
          "display_phone": "+65 6996 3937",
          "distance": 478.7545503958125
        },
        {
          "id": "kmxBcy--om2MmWXYKznTKw",
          "alias": "maria-virgin-chicken-singapore",
          "name": "Maria Virgin Chicken",
          "image_url": "https://s3-media1.fl.yelpcdn.com/bphoto/ymRtIKNVJRxUtvaJeX4dZQ/o.jpg",
          "is_closed": false,
          "url": "https://www.yelp.com/biz/maria-virgin-chicken-singapore?adjust_creative=L2DNe2W3HxwxlaFN2D-DJg&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=L2DNe2W3HxwxlaFN2D-DJg",
          "review_count": 2,
          "categories": [
            {
              "alias": "cantonese",
              "title": "Cantonese"
            }
          ],
          "rating": 4.5,
          "coordinates": {
            "latitude": 1.28218,
            "longitude": 103.84317
          },
          "transactions": [],
          "location": {
            "address1": "335 Smith St",
            "address2": "#02-189",
            "address3": "Chinatown Complex Market & Food Centre",
            "city": "Singapore",
            "zip_code": "050335",
            "country": "SG",
            "state": "SG",
            "display_address": [
              "335 Smith St",
              "#02-189",
              "Chinatown Complex Market & Food Centre",
              "Singapore 050335",
              "Singapore"
            ]
          },
          "phone": "",
          "display_phone": "",
          "distance": 274.70245388990696
        },
        {
          "id": "6LgTc7CZlXCd1Pxq3BiVcw",
          "alias": "jumbo-seafood-singapore-4",
          "name": "Jumbo Seafood",
          "image_url": "https://s3-media3.fl.yelpcdn.com/bphoto/0LjyCOL5rvnx0l26UaMKfw/o.jpg",
          "is_closed": false,
          "url": "https://www.yelp.com/biz/jumbo-seafood-singapore-4?adjust_creative=L2DNe2W3HxwxlaFN2D-DJg&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=L2DNe2W3HxwxlaFN2D-DJg",
          "review_count": 201,
          "categories": [
            {
              "alias": "seafood",
              "title": "Seafood"
            }
          ],
          "rating": 4,
          "coordinates": {
            "latitude": 1.28892873710895,
            "longitude": 103.848373889923
          },
          "transactions": [],
          "price": "$$$",
          "location": {
            "address1": "20 Upper Circular Road",
            "address2": "#B1-48",
            "address3": "",
            "city": "Singapore",
            "zip_code": "058416",
            "country": "SG",
            "state": "SG",
            "display_address": [
              "20 Upper Circular Road",
              "#B1-48",
              "Singapore 058416",
              "Singapore"
            ]
          },
          "phone": "+6565343435",
          "display_phone": "+65 6534 3435",
          "distance": 970.7010551015062
        },
        {
          "id": "BefMNoY4pjBTCembggZRaw",
          "alias": "cloudstreet-singapore",
          "name": "Cloudstreet",
          "image_url": "https://s3-media1.fl.yelpcdn.com/bphoto/i4rXIYdfSMH9ZRw6HUp6Lg/o.jpg",
          "is_closed": false,
          "url": "https://www.yelp.com/biz/cloudstreet-singapore?adjust_creative=L2DNe2W3HxwxlaFN2D-DJg&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=L2DNe2W3HxwxlaFN2D-DJg",
          "review_count": 2,
          "categories": [
            {
              "alias": "srilankan",
              "title": "Sri Lankan"
            },
            {
              "alias": "australian",
              "title": "Australian"
            },
            {
              "alias": "wine_bars",
              "title": "Wine Bars"
            }
          ],
          "rating": 5,
          "coordinates": {
            "latitude": 1.28079,
            "longitude": 103.84698
          },
          "transactions": [],
          "location": {
            "address1": "84 Amoy St",
            "address2": "",
            "address3": null,
            "city": "Singapore",
            "zip_code": "069903",
            "country": "SG",
            "state": "SG",
            "display_address": [
              "84 Amoy St",
              "Singapore 069903",
              "Singapore"
            ]
          },
          "phone": "+6565137868",
          "display_phone": "+65 6513 7868",
          "distance": 741.795909960251
        },
        {
          "id": "73G2fb9fQ1bHRqns3cikmA",
          "alias": "man-man-japanese-unagi-singapore",
          "name": "Man Man Japanese Unagi",
          "image_url": "https://s3-media1.fl.yelpcdn.com/bphoto/O7IShQvGWku0u6y9uTohzA/o.jpg",
          "is_closed": false,
          "url": "https://www.yelp.com/biz/man-man-japanese-unagi-singapore?adjust_creative=L2DNe2W3HxwxlaFN2D-DJg&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=L2DNe2W3HxwxlaFN2D-DJg",
          "review_count": 22,
          "categories": [
            {
              "alias": "japanese",
              "title": "Japanese"
            }
          ],
          "rating": 5,
          "coordinates": {
            "latitude": 1.27908,
            "longitude": 103.84139
          },
          "transactions": [],
          "price": "$$",
          "location": {
            "address1": "1 Keong Saik Rd",
            "address2": "#01-01",
            "address3": null,
            "city": "Singapore",
            "zip_code": "089109",
            "country": "SG",
            "state": "SG",
            "display_address": [
              "1 Keong Saik Rd",
              "#01-01",
              "Singapore 089109",
              "Singapore"
            ]
          },
          "phone": "+6562220678",
          "display_phone": "+65 6222 0678",
          "distance": 529.9344895875279
        },
        {
          "id": "o1_iIC0rU2yuF3SZvf6IjA",
          "alias": "hai-di-lao-singapore-4",
          "name": "Hai Di Lao",
          "image_url": "https://s3-media2.fl.yelpcdn.com/bphoto/OdNGjR6gcoGz1vK7em8L-w/o.jpg",
          "is_closed": false,
          "url": "https://www.yelp.com/biz/hai-di-lao-singapore-4?adjust_creative=L2DNe2W3HxwxlaFN2D-DJg&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=L2DNe2W3HxwxlaFN2D-DJg",
          "review_count": 46,
          "categories": [
            {
              "alias": "hotpot",
              "title": "Hot Pot"
            },
            {
              "alias": "szechuan",
              "title": "Szechuan"
            }
          ],
          "rating": 4,
          "coordinates": {
            "latitude": 1.289833,
            "longitude": 103.845535
          },
          "transactions": [],
          "price": "$$$",
          "location": {
            "address1": "3D River Valley Rd",
            "address2": "#02-04",
            "address3": null,
            "city": "Singapore",
            "zip_code": "179023",
            "country": "SG",
            "state": "SG",
            "display_address": [
              "3D River Valley Rd",
              "#02-04",
              "Singapore 179023",
              "Singapore"
            ]
          },
          "phone": "+6563378626",
          "display_phone": "+65 6337 8626",
          "distance": 807.1263377022052
        },
        {
          "id": "mrFDNv0YDbJxJk8hkEqcWg",
          "alias": "city-satay-smith-street-singapore",
          "name": "City Satay Smith Street",
          "image_url": "https://s3-media2.fl.yelpcdn.com/bphoto/mCgmn5bSkcyrd0OvIlf89g/o.jpg",
          "is_closed": false,
          "url": "https://www.yelp.com/biz/city-satay-smith-street-singapore?adjust_creative=L2DNe2W3HxwxlaFN2D-DJg&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=L2DNe2W3HxwxlaFN2D-DJg",
          "review_count": 2,
          "categories": [
            {
              "alias": "singaporean",
              "title": "Singaporean"
            },
            {
              "alias": "streetvendors",
              "title": "Street Vendors"
            },
            {
              "alias": "importedfood",
              "title": "Imported Food"
            }
          ],
          "rating": 4.5,
          "coordinates": {
            "latitude": 1.28218,
            "longitude": 103.8431702
          },
          "transactions": [],
          "price": "$",
          "location": {
            "address1": "Chinatown Complex Food Centre, 335 Smith Street",
            "address2": "Stall No. 3, Chinatown Complex",
            "address3": "",
            "city": "Singapore",
            "zip_code": "050335",
            "country": "SG",
            "state": "SG",
            "display_address": [
              "Chinatown Complex Food Centre, 335 Smith Street",
              "Stall No. 3, Chinatown Complex",
              "Singapore 050335",
              "Singapore"
            ]
          },
          "phone": "+6563720478",
          "display_phone": "+65 6372 0478",
          "distance": 276.09927810212974
        },
        {
          "id": "fY1IkBnRft1KR0O2tqu7pg",
          "alias": "tian-tian-hainanese-chicken-rice-singapore-7",
          "name": "Tian Tian Hainanese Chicken Rice",
          "image_url": "https://s3-media3.fl.yelpcdn.com/bphoto/UJ5Kp3NWi5vyCnUf_ftiFQ/o.jpg",
          "is_closed": false,
          "url": "https://www.yelp.com/biz/tian-tian-hainanese-chicken-rice-singapore-7?adjust_creative=L2DNe2W3HxwxlaFN2D-DJg&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=L2DNe2W3HxwxlaFN2D-DJg",
          "review_count": 406,
          "categories": [
            {
              "alias": "hainan",
              "title": "Hainan"
            },
            {
              "alias": "chickenshop",
              "title": "Chicken Shop"
            }
          ],
          "rating": 4,
          "coordinates": {
            "latitude": 1.28035,
            "longitude": 103.84472
          },
          "transactions": [],
          "price": "$",
          "location": {
            "address1": "1 Kadayanallur St",
            "address2": "#01 -10/11",
            "address3": "Maxwell Food Center",
            "city": "Singapore",
            "zip_code": "069120",
            "country": "SG",
            "state": "SG",
            "display_address": [
              "1 Kadayanallur St",
              "#01 -10/11",
              "Maxwell Food Center",
              "Singapore 069120",
              "Singapore"
            ]
          },
          "phone": "+6596914852",
          "display_phone": "+65 9691 4852",
          "distance": 599.1598681458519
        },
        {
          "id": "MP75PUqBKu9kc-Et_64kXg",
          "alias": "outram-park-fried-kway-teow-mee-singapore-2",
          "name": "Outram Park Fried Kway Teow Mee",
          "image_url": "https://s3-media3.fl.yelpcdn.com/bphoto/ByS6_1iGeSM2Sk7yE66n4w/o.jpg",
          "is_closed": false,
          "url": "https://www.yelp.com/biz/outram-park-fried-kway-teow-mee-singapore-2?adjust_creative=L2DNe2W3HxwxlaFN2D-DJg&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=L2DNe2W3HxwxlaFN2D-DJg",
          "review_count": 32,
          "categories": [
            {
              "alias": "singaporean",
              "title": "Singaporean"
            },
            {
              "alias": "foodstands",
              "title": "Food Stands"
            },
            {
              "alias": "noodles",
              "title": "Noodles"
            }
          ],
          "rating": 4,
          "coordinates": {
            "latitude": 1.285331,
            "longitude": 103.845857
          },
          "transactions": [],
          "price": "$",
          "location": {
            "address1": "531A Upper Cross St",
            "address2": "#02-17",
            "address3": "Hong Lim Food Center",
            "city": "Singapore",
            "zip_code": "051531",
            "country": "SG",
            "state": "SG",
            "display_address": [
              "531A Upper Cross St",
              "#02-17",
              "Hong Lim Food Center",
              "Singapore 051531",
              "Singapore"
            ]
          },
          "phone": "+6598387619",
          "display_phone": "+65 9838 7619",
          "distance": 545.097360059801
        },
        {
          "id": "YnnYwfMEeSru_cJ_qKeofw",
          "alias": "cherry-garden-singapore",
          "name": "Cherry Garden",
          "image_url": "https://s3-media1.fl.yelpcdn.com/bphoto/7B5uDtFJS3_1PlcMzR8YrQ/o.jpg",
          "is_closed": false,
          "url": "https://www.yelp.com/biz/cherry-garden-singapore?adjust_creative=L2DNe2W3HxwxlaFN2D-DJg&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=L2DNe2W3HxwxlaFN2D-DJg",
          "review_count": 15,
          "categories": [
            {
              "alias": "cantonese",
              "title": "Cantonese"
            }
          ],
          "rating": 4,
          "coordinates": {
            "latitude": 1.29063,
            "longitude": 103.85844
          },
          "transactions": [],
          "price": "$$$$",
          "location": {
            "address1": "5 Raffles Avenue",
            "address2": "Marina Square",
            "address3": null,
            "city": "Singapore",
            "zip_code": "039797",
            "country": "SG",
            "state": "SG",
            "display_address": [
              "5 Raffles Avenue",
              "Marina Square",
              "Singapore 039797",
              "Singapore"
            ]
          },
          "phone": "+6568853500",
          "display_phone": "+65 6885 3500",
          "distance": 2048.0879259160347
        },
        {
          "id": "btO8LR37d7EHakcRl-Myrg",
          "alias": "mount-faber-nasi-lemak-singapore",
          "name": "Mount Faber Nasi Lemak",
          "image_url": "https://s3-media3.fl.yelpcdn.com/bphoto/2knj4GZXrWufbARBkMekwQ/o.jpg",
          "is_closed": false,
          "url": "https://www.yelp.com/biz/mount-faber-nasi-lemak-singapore?adjust_creative=L2DNe2W3HxwxlaFN2D-DJg&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=L2DNe2W3HxwxlaFN2D-DJg",
          "review_count": 4,
          "categories": [
            {
              "alias": "singaporean",
              "title": "Singaporean"
            },
            {
              "alias": "nasilemak",
              "title": "Nasi Lemak"
            }
          ],
          "rating": 4.5,
          "coordinates": {
            "latitude": 1.2810565,
            "longitude": 103.8420766
          },
          "transactions": [],
          "price": "$",
          "location": {
            "address1": "47 Kreta Ayer Rd",
            "address2": "",
            "address3": "",
            "city": "Singapore",
            "zip_code": "089006",
            "country": "SG",
            "state": "SG",
            "display_address": [
              "47 Kreta Ayer Rd",
              "Singapore 089006",
              "Singapore"
            ]
          },
          "phone": "+6597889899",
          "display_phone": "+65 9788 9899",
          "distance": 351.83772847952116
        },
        {
          "id": "rvV7sbuyQFSjjtvb4vjdWQ",
          "alias": "ya-kun-kaya-toast-singapore-9",
          "name": "Ya Kun Kaya Toast",
          "image_url": "https://s3-media3.fl.yelpcdn.com/bphoto/HDOtmi7siaguhK6ffQXUtQ/o.jpg",
          "is_closed": false,
          "url": "https://www.yelp.com/biz/ya-kun-kaya-toast-singapore-9?adjust_creative=L2DNe2W3HxwxlaFN2D-DJg&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=L2DNe2W3HxwxlaFN2D-DJg",
          "review_count": 44,
          "categories": [
            {
              "alias": "singaporean",
              "title": "Singaporean"
            },
            {
              "alias": "coffee",
              "title": "Coffee & Tea"
            },
            {
              "alias": "bakeries",
              "title": "Bakeries"
            }
          ],
          "rating": 4,
          "coordinates": {
            "latitude": 1.28298,
            "longitude": 103.84784
          },
          "transactions": [],
          "price": "$",
          "location": {
            "address1": "18 China Street",
            "address2": "#01-01",
            "address3": "",
            "city": "Singapore",
            "zip_code": "049560",
            "country": "SG",
            "state": "SG",
            "display_address": [
              "18 China Street",
              "#01-01",
              "Singapore 049560",
              "Singapore"
            ]
          },
          "phone": "+6564383638",
          "display_phone": "+65 6438 3638",
          "distance": 763.6245456281774
        },
        {
          "id": "dUUJ2-v8Vltv4FkUB55bog",
          "alias": "lukes-oyster-bar-and-chop-house-singapore",
          "name": "Luke's Oyster Bar & Chop House",
          "image_url": "https://s3-media3.fl.yelpcdn.com/bphoto/vmIwMvbTi_jABu0DzCK7WA/o.jpg",
          "is_closed": false,
          "url": "https://www.yelp.com/biz/lukes-oyster-bar-and-chop-house-singapore?adjust_creative=L2DNe2W3HxwxlaFN2D-DJg&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=L2DNe2W3HxwxlaFN2D-DJg",
          "review_count": 24,
          "categories": [
            {
              "alias": "seafood",
              "title": "Seafood"
            },
            {
              "alias": "tradamerican",
              "title": "American (Traditional)"
            }
          ],
          "rating": 4,
          "coordinates": {
            "latitude": 1.28220557076192,
            "longitude": 103.847273979762
          },
          "transactions": [],
          "price": "$$$$",
          "location": {
            "address1": "22 Gemmill Ln",
            "address2": "",
            "address3": "",
            "city": "Singapore",
            "zip_code": "069257",
            "country": "SG",
            "state": "SG",
            "display_address": [
              "22 Gemmill Ln",
              "Singapore 069257",
              "Singapore"
            ]
          },
          "phone": "+6562214468",
          "display_phone": "+65 6221 4468",
          "distance": 715.1157053959726
        }
      ],
      "total": 6400,
      "region": {
        "center": {
          "longitude": 103.841114,
          "latitude": 1.284066
        }
      }
    }
"""

        return json
    }
}
