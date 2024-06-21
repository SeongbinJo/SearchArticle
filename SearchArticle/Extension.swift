//
//  Extension.swift
//  SearchArticle
//
//  Created by 조성빈 on 6/21/24.
//

import Foundation

extension Bundle {
    var client_Id: String? {
        return infoDictionary?["Client_ID"] as? String
    }
    
    var client_Secret: String? {
        return infoDictionary?["Client_Secret"] as? String
    }
}
