//
//  HealthSnapViewModel.swift
//  HealthSnap
//
//  Created by swiftandcurious on 18/01/2026.
//

import Foundation
import HealthKit
import Combine

@MainActor
final class HealthSnapViewModel: ObservableObject {
    @Published var metrics: [HealthMetric] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var hasHealthAccess = false

    private let hkm = HealthKitManager(healthStore: HKHealthStore())

    var canUseHealthKit: Bool {
        hkm.isHealthDataAvailable
    }

    func onAppear() async {
        await refresh()
    }

    func requestAccess() async {
        errorMessage = nil
        isLoading = true
        defer { isLoading = false }

        do {
            try await hkm.requestAuthorisation()
            try await loadSnapshot()
            hasHealthAccess = true
        } catch {
            hasHealthAccess = false
            errorMessage = error.localizedDescription
        }
    }

    func refresh() async {
        guard canUseHealthKit else {
            hasHealthAccess = false
            errorMessage = "Health data is not available on this device."
            return
        }

        errorMessage = nil
        isLoading = true
        defer { isLoading = false }

        do {
            try await loadSnapshot()
            hasHealthAccess = true
        } catch {
            hasHealthAccess = false
            errorMessage = error.localizedDescription
        }
    }

    private func loadSnapshot() async throws {
        let snapshot = try await hkm.fetchTodaySnapshot()

        let stepsValue = Int(snapshot.steps.rounded())
        let activeEnergyValue = Int(snapshot.activeEnergyKcal.rounded())
        let exerciseMinutesValue = Int(snapshot.exerciseMinutes.rounded())
        let standMinutesValue = Int(snapshot.standMinutes.rounded())
        let standHoursValue = Int(snapshot.standHours)

        let stepsMetric = HealthMetric(
            title: "Steps",
            valueText: "\(stepsValue)",
            systemImage: "figure.walk",
            footnote: "Today"
        )

        let activeEnergyMetric = HealthMetric(
            title: "Active Energy",
            valueText: "\(activeEnergyValue) kcal",
            systemImage: "flame",
            footnote: "Today"
        )

        let exerciseMetric = HealthMetric(
            title: "Exercise",
            valueText: "\(exerciseMinutesValue) min",
            systemImage: "figure.run",
            footnote: "Today"
        )

        let standMetric = HealthMetric(
            title: "Stand",
            valueText: "\(standHoursValue) times, \(standMinutesValue) min",
            systemImage: "figure.stand",
            footnote: "Stand Time (today)"
        )

        metrics = [
            stepsMetric,
            activeEnergyMetric,
            exerciseMetric,
            standMetric
        ]
    }
}

