//
//  Array+Extension.swift
//  TakingOrderApp
//
//  Created by Meriç Keskin on 27.09.2022.
//

import Foundation

extension Array {
    public func toDictionary<Key:Hashable>(key: (Element) -> Key, value: AnyHashable) -> [Key:AnyHashable] {
            var dict = [Key:AnyHashable]()
            for element in self {
                dict[key(element)] = value
            }
            return dict
        }
}
