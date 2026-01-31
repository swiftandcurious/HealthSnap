//
//  ContentView.swift
//  HealthSnap
//
//  Created by swiftandcurious on 18/01/2026.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var vm = HealthSnapViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if !vm.canUseHealthKit {
                    unavailableView
                } else if !vm.hasHealthAccess {
                    permissionView
                } else {
                    snapshotView
                }
            }
            .navigationTitle("Daily Health Snapshot")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task { await vm.refresh() }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                    .disabled(!vm.hasHealthAccess || vm.isLoading)
                }
            }
        }
        .task {
            await vm.onAppear()
        }
    }

    // MARK: - Snapshot

    private var snapshotView: some View {
        ScrollView {
            VStack(spacing: 14) {
                if vm.isLoading {
                    ProgressView("Loading Health data…")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                if let error = vm.errorMessage {
                    errorBanner(error)
                }

                ForEach(vm.metrics) { metric in
                    MetricCardView(metric: metric)
                }
            }
            .padding()
        }
        .refreshable {
            await vm.refresh()
        }
    }

    // MARK: - Permission

    private var permissionView: some View {
        VStack(spacing: 16) {
            Image(systemName: "heart.text.square")
                .font(.system(size: 44))
                .padding(.bottom, 6)

            Text("Connect to Health")
                .font(.title2)
                .fontWeight(.semibold)

            Text("HealthSnap reads your activity metrics to show a simple overview of today’s movement. Nothing is stored outside your device.")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            if let error = vm.errorMessage {
                errorBanner(error)
                    .padding(.horizontal)
            }

            Button {
                Task { await vm.requestAccess() }
            } label: {
                if vm.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                } else {
                    Text("Allow Health Access")
                        .frame(maxWidth: .infinity)
                }
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)
            .disabled(vm.isLoading || !vm.canUseHealthKit)

            // Optional helper button: if user already granted access in Settings,
            // this lets them try loading again without re-triggering authorization.
            Button("I already allowed access — Load snapshot") {
                Task { await vm.refresh() }
            }
            .font(.footnote)
            .padding(.top, 4)
        }
        .padding()
    }

    // MARK: - Unavailable

    private var unavailableView: some View {
        ContentUnavailableView(
            "Health data unavailable",
            systemImage: "exclamationmark.triangle",
            description: Text("This device doesn’t support HealthKit.")
        )
        .padding()
    }

    // MARK: - Error UI

    private func errorBanner(_ message: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "exclamationmark.circle.fill")
            Text(message)
            Spacer()
        }
        .font(.footnote)
        .foregroundStyle(.secondary)
        .padding(12)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

#Preview {
    ContentView()
}

