//
//  ParcelInvoiceMaker - ParcelProcessor.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import Foundation

struct ParcelInformation {
    var receiverInformation : ReceiverInformation // 변하니까 var
    let deliveryCost: DeliveryCost //
    init(receiverInformation : ReceiverInformation, deliveryCost: DeliveryCost) {
        self.receiverInformation = receiverInformation
        self.deliveryCost = deliveryCost
    }
}
// private 과 var , let을 해줘야하는 기준이 헷갈린다. 처음 설정할때 말고 변할일 없으니까 let 이라고 생각
struct ReceiverInformation{
    let address : String
    let name : String
    let mobile : String
    init(address: String, name: String, mobile: String) {
        self.address = address
        self.name = name
        self.mobile = mobile
    }
}
// DiscountCost 에 대한 부분은 따로 분리하고 싶어서 할인해주는것도 분리 시
struct DeliveryCost {
    let deliveryCost : Int
    private let discount : Discount
    var discountedCost : Int {
        switch discount {
        case .none:
            return deliveryCost
        case .vip:
            return deliveryCost / 20
        case .coupon:
            return deliveryCost / 2
        }
    }
}

enum Discount: Int {
    case none = 0, vip, coupon
}
protocol ParcelInformationPersistence {
    func save(parcelInformation : ParcelInformation, _ onComplete : (ParcelInformation) -> Void)

}
class ParcelOrderProcessor {
    // 이러면 접근할때 꼭 넣어야하는 값인지 어떻게 알지궁금
    var delegate : ParcelInformationPersistence // 소유하고

    init(delegate: ParcelInformationPersistence, parcelInformation: ParcelInformation? = nil) {
        self.delegate = DatabaseParcelInformationPersistence()
    }
    
    func process(parcelInformation : ParcelInformation){
        delegate.save(parcelInformation: parcelInformation, { _ in
            print("저장에 성공했습니다.")
        })
    }
}
class DatabaseParcelInformationPersistence : ParcelInformationPersistence{
    // 클로저를 사용하는 이유가 데이터베이스 저장에 실패했을 경우도 생각해서 하는건지 궁금
    func save(parcelInformation : ParcelInformation, _ onComplete : (ParcelInformation) -> Void){
        print("발송 정보를 데이터베이스에 저장했습니다.")
        onComplete(parcelInformation)
    }
}
