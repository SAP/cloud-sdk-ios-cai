//
//  File.swift
//  
//
//  Created by Eidinger, Marco on 6/9/21.
//

import Foundation

struct AnyEncodable : Encodable {
  var value: Encodable
  init(_ value: Encodable) {
    self.value = value
  }
  func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try value.encode(to: &container)
  }
}

extension Encodable {
  fileprivate func encode(to container: inout SingleValueEncodingContainer) throws {
    try container.encode(self)
  }
}
