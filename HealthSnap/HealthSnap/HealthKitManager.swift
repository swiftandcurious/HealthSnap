//
//  HealthKitManager.swift
//  HealthSnap
//
//  Created by swiftandcurious on 18/01/2026.
//

import Foundation
import HealthKit

final class HealthKitManager {
    
    private let healthStore: HKHealthStore
    
    init(healthStore: HKHealthStore) {
        self.healthStore = healthStore
    }
    
    var isHealthDataAvailable: Bool {
        return HKHealthStore.isHealthDataAvailable()
    }
    
    func requestAuthorisation() async throws {
        guard isHealthDataAvailable else {
            throw HealthKitError.healthDataNotAvailable
        }

        guard
            let steps = HKObjectType.quantityType(forIdentifier: .stepCount),
            let activeEnergy = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned),
            let exerciseTime = HKObjectType.quantityType(forIdentifier: .appleExerciseTime),
            let standTime = HKObjectType.quantityType(forIdentifier: .appleStandTime),
            let standHour = HKObjectType.categoryType(forIdentifier: .appleStandHour)
        else {
            throw HealthKitError.typeNotAvailable("One of the HealthKit types could not be created.")
        }

        let readTypes: Set<HKObjectType> = [steps, activeEnergy, exerciseTime, standTime, standHour]
        try await healthStore.requestAuthorization(toShare: [], read: readTypes)
    }
    
    func authorisationStatus(for identifier: HKQuantityTypeIdentifier) async throws -> HKAuthorizationStatus {
        guard let type = HKObjectType.quantityType(forIdentifier: identifier) else {
            return .notDetermined
        }
        return healthStore.authorizationStatus(for: type)
    }
    
    func fetchTodaySnapshot() async throws -> TodaySnapshot {
        async let steps = fetchTodaySum(.stepCount, unit: .count())
        async let activeEnergy = fetchTodaySum(.activeEnergyBurned, unit: .kilocalorie())
        async let exerciseMinutes = fetchTodaySum(.appleExerciseTime, unit: .minute())
        async let standMinutes = fetchTodaySum(.appleStandTime, unit: .minute())
        async let standHours = fetchTodayStandHours()

        return try await TodaySnapshot(
            steps: steps,
            activeEnergyKcal: activeEnergy,
            exerciseMinutes: exerciseMinutes,
            standMinutes: standMinutes,
            standHours: standHours
        )
    }
    
    func fetchTodayStandHours() async throws -> Int {
        guard let standHourType = HKObjectType.categoryType(forIdentifier: .appleStandHour) else {
            throw HealthKitError.typeNotAvailable(HKCategoryTypeIdentifier.appleStandHour.rawValue)
        }

        let startOfDay = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)

        return try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: standHourType,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: nil
            ) { _, samples, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }

                let stoodValue = HKCategoryValueAppleStandHour.stood.rawValue

                let hours = (samples as? [HKCategorySample])?
                    .filter { $0.value == stoodValue }
                    .count ?? 0

                continuation.resume(returning: hours)
            }

            self.healthStore.execute(query)
        }
    }
    
    
    private func fetchTodaySum(_ identifier: HKQuantityTypeIdentifier, unit: HKUnit) async throws -> Double {
        guard let quantityType = HKQuantityType.quantityType(forIdentifier: identifier) else {
            throw HealthKitError.typeNotAvailable(identifier.rawValue)
        }

        let startOfDay = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)

        return try await withCheckedThrowingContinuation { continuation in
            let query = HKStatisticsQuery(quantityType: quantityType,
                                          quantitySamplePredicate: predicate,
                                          options: .cumulativeSum) { _, statistics, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }

                let sum = statistics?.sumQuantity()?.doubleValue(for: unit) ?? 0
                continuation.resume(returning: sum)
            }

            healthStore.execute(query)
        }
    }
    
}

