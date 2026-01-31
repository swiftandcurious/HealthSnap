//
//  MetricCardView.swift
//  HealthSnap
//
//  Created by swiftandcurious on 18/01/2026.
//

import SwiftUI

struct MetricCardView: View {
    let metric: HealthMetric

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                Image(systemName: metric.systemImage)
                    .font(.title3)

                Text(metric.title)
                    .font(.headline)

                Spacer()
            }

            Text(metric.valueText)
                .font(.system(.title, design: .rounded))
                .fontWeight(.semibold)

            if let footnote = metric.footnote {
                Text(footnote)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(14)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

#Preview {
    MetricCardView(
        metric: HealthMetric(
            title: "Heart Rate",
            valueText: "72 bpm",
            systemImage: "heart.fill",
            footnote: "Resting"
        )
    )
}
