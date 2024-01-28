//
//  ParcelInformation.swift
//  ParcelInvoiceMaker
//
//  Created by kodirbek on 1/24/24.
//

import Foundation


struct Address {
    private(set) var address: String
    
    init(_ address: String) {
        self.address = address
    }
}


struct Receiver {
    private(set) var name: String
    private(set) var mobile: String
    
    init(name: String, mobile: String) {
        self.name = name
        self.mobile = mobile
    }
}


// cost가 음수 아닌지 확인하기 위해 init()에서 배송 비용을 검증합니다.
struct DeliveryCost {
    private(set) var cost: Double
    
    private static func validate(_ cost: Double) -> Bool {
        return cost >= 0
    }
    
    init?(_ cost: Double) {
        guard Self.validate(cost) else {
            print("Invalid cost: Cost must be greater than or equal to 0.")
            return nil
        }
        self.cost = cost
    }
}


// 원칙 2 'else 사용 금지'에서 볼 수 있듯이 여기에서는 전략 패턴을 사용했습니다. DiscountedCost와 ParcelInformation를 변경하지 않고도 쉽게 할인 유형을 확장할 수 있다는 장점이 있습니다. 테스트로 "HolidayDiscount"라는 새로운 유형의 할인 정책을 추가했습니다. 디스카운트 전략(DiscountStrategy) 프로토콜을 준수하는 새로운 HolidayDiscount 구조체를 생성했고, Discount 열거형에 새로운 'holiday' 케이스를 추가했고, 마지막으로 ParcelOrderView의 currentDiscountStrategies 배열에 새로운 전략을 추가하는 것만으로만 충분했습니다. 여기서 OCP를 따르는 것의 장점을 느꼈습니다.
struct DiscountCostCalculator {
    private let deliveryCost: DeliveryCost
    private let discount: Discount
    private let discountStrategies: [DiscountStrategy]
    
    init(deliveryCost: DeliveryCost, discount: Discount, discountStrategies: [DiscountStrategy]) {
        self.deliveryCost = deliveryCost
        self.discount = discount
        self.discountStrategies = discountStrategies
    }
    
    func getDiscountedCost() -> Int {
        discountStrategies.filter {$0.canAccept(discount: discount)}
            .first?
            .applyDiscount(deliveryCost: deliveryCost, discountRate: discount.rate) ?? Int(deliveryCost.cost)
    }
}


struct ParcelInformation {
    private(set) var addressInfo: Address
    private(set) var receiver: Receiver
    private(set) var discountCostCalculator: DiscountCostCalculator
    
    init(address: Address, receiverInfo: Receiver, discountCostCalculator: DiscountCostCalculator) {
        self.addressInfo = address
        self.receiver = receiverInfo
        self.discountCostCalculator = discountCostCalculator
    }
    
    // InvoiceView 안에선 '4원칙: 한 줄에 한 점만 사용'을 지키기 위해서 함수 추가
    func getDiscountedCost() -> Int {
        discountCostCalculator.getDiscountedCost()
    }
    
}


