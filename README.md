# HealthSnap 🩺✨  
_A gentle snapshot of your daily movement_

**HealthSnap** is a small SwiftUI app that shows a readable snapshot of today’s movement using **Apple HealthKit**.

The app reads data that already exists on your iPhone and Apple Watch and presents it in one clean, respectful view.

---

## ✨ What HealthSnap shows

- **Steps** (today)
- **Move** — Active Energy (kcal)
- **Exercise** — Exercise Time (minutes)
- **Stand** — Stand **hours** (ring metric) and stand time (minutes)

All values are read-only. HealthSnap never writes data back to Health.

The app will look like this:

![HealthSnap](HealthSnapScreenshotMiddle.png)

If you want to code along, please visit [swiftandcurious](https://swiftandcurious.com) You can find here the code-along for HealthSnap.

---

## 🧠 What this project is about

This project is designed as a **learning-focused code-along**, not a production fitness tracker.

It demonstrates how to:

- Set up **HealthKit** correctly (capabilities + privacy permissions)
- Build a clean **permission flow** in SwiftUI
- Read HealthKit **quantity types** (steps, calories, minutes)
- Handle **category samples** correctly (stand hours)
- Use **Swift concurrency** (`async/await`, `async let`) with HealthKit
- Build a simple, Apple-style snapshot UI
- Understand why Health data (especially steps) may differ slightly between apps

---

## 📱 Requirements

- iOS 17 or later (recommended)
- Xcode 15+
- A **real iPhone** (HealthKit works best on physical devices)
- Health data available (iPhone, Apple Watch, or both)

> HealthKit is not fully supported on simulators.

---

## 🚀 Getting started

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/HealthSnap.git
   ```
2. Open HealthSnap.xcodeproj in Xcode.
3. Select a **real iPhone** as the run destination.
4. Enable **HealthKit** under _Signing & Capabilities_.
5. Run the app and allow Health access when prompted.

---

## **🔐 Privacy & permissions**

HealthSnap requests **read-only** access to the following Health data:
- Steps (stepCount)
- Active Energy (activeEnergyBurned)
- Exercise Time (appleExerciseTime)
- Stand Time (appleStandTime)
- Stand Hours (appleStandHour)

The app does **not** store, upload, or share any Health data.

---

## **🤔 Why steps might not match exactly**

You may notice small differences between HealthSnap’s step count and Apple’s Fitness app. This is normal and can happen due to:
- Multiple data sources (iPhone + Apple Watch)
- Sync timing delays
- Different aggregation and rounding strategies

HealthSnap uses a simple, reliable “today’s sum” approach to keep the code easy to understand.

---

## **📚 Part of a code-along series**

This project is part of the **swiftandcurious** newsletter and code-along series, where we build small, meaningful apps while learning Apple frameworks step by step.  

👉 Learn more at: **https://swiftandcurious.com**

---

## **❤️ A note on intent**

HealthSnap is intentionally small.

It’s not about performance, optimisation, or competition - it’s about learning HealthKit responsibly and designing calm, respectful experiences.

---

Happy coding!

**Stay hungry. Stay foolish.**

— _Steve Jobs_

## 👩‍💻 About the Creator

This project is part of the [swiftandcurious](https://swiftandcurious.com) initiative — inspiring and empowering self-taught developers to explore Swift, step by step.

Created by [Karina Schreiber](https://swiftandcurious.com), a hobby app developer and curious mind.

Follow along on [X/Twitter](https://twitter.com/swiftandcurious) for more SwiftUI tutorials and code-alongs!