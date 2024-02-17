//
//  USIVRequest.swift
//  usiv-request
//
//  Created by Kevin Ravakhah on 2/12/24.
//

import Foundation

struct USIVRequest: Identifiable, Codable {
    var id: UUID
    var hospital: String
    var roomNumber: Int
    var callBackNumber: String
    var notes: String
    var status: Int
}
