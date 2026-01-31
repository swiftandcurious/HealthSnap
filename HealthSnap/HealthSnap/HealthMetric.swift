//
//  HealthMetric.swift
//  HealthSnap
//
//  Created by swiftandcurious on 18/01/2026.
//

import Foundation

struct HealthMetric: Identifiable {
    let id = UUID()
    let title: String
    let valueText: String
    let systemImage: String
    let footnote: String?
}
