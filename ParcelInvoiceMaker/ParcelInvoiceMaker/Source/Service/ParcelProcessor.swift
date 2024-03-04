//
//  ParcelInvoiceMaker - ParcelProcessor.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
// 

import Foundation

protocol ParcelOrderProcessable {
    func process(parcelInformation: ParcelInformation,
                 onComplete: (ParcelInformation) -> Void)
}

final class ParcelOrderProcessor: ParcelOrderProcessable {
    private let persistence: ParcelInformationPersistence
    
    init(persistence: ParcelInformationPersistence) {
        self.persistence = persistence
    }
    
    // 택배 주문 처리 로직
    func process(parcelInformation: ParcelInformation, 
                 onComplete: (ParcelInformation) -> Void) {
        
        // 데이터베이스에 주문 저장
        self.persistence.save(parcelInformation: parcelInformation)
        
        onComplete(parcelInformation)
    }
}
