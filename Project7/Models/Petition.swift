//
//  Petition.swift
//  Project7
//
//  Created by Pradeep Reddy Kypa on 24/06/21.
//

import Foundation

struct Petition :Codable {
    let title :String
    let body: String
    let signatureThreshold :Int
    let signatureCount :Int
    let signaturesNeeded : Int
}
