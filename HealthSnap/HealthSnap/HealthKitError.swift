//
//  HealthKitError.swift
//  HealthSnap
//
//  Created by swiftandcurious on 18/01/2026.
//

import Foundation

enum HealthKitError: LocalizedError {
    case healthDataNotAvailable
    case typeNotAvailable(String)

    var errorDescription: String? {
        switch self {
        case .healthDataNotAvailable:
            return "Health data is not available on this device."
        case .typeNotAvailable(let type):
            return "Health data type not available: \(type)"
        }
    }
}
