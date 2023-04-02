# Football App

## Assignment

Build an iOS football app that shows matches and highlights.

### Functional Requirements

• Display previous and upcoming matches. ✅
• Select a team for team details. ✅
• Filter matches by team(s). ✅
• Watch highlights of a previous match. ✅

### Coding Requirements

• Use UIKit and Combine (functional reactive programming). ✅
• Build the entire project’s UI programmatically. ✅
• Present lists using collection view diffable data source. ✅
• Following MVVM design pattern, discern files using the feature-first approach. ✅
• Integrate Core Data to sync matches and teams for offline access. ✅
• Conform to API Design Guidelines (https://bit.ly/3ZqnUXO). ✅
• Conform to Swift Style Guide (https://bit.ly/3YicMuO). ✅

### Coding Requirements (Bonuses)

• Encapsulate business/UI logic with Swift Package(s). ✅
• Integrate unit testing bundle with appropriate unit tests for code coverage. ⌛
• Integrate unit testing bundle with snapshot tests for UI components comparisons. ⌛
• Integrate UI testing bundle with appropriate UI tests to simulate user interactions. ⌛
• Limit third-party dependencies (zero is the best). (Current: 2 dependencies: `SDWebImage`, `SnapshotTesting`) ❌

### Backend APIs

Get Teams https://jmde6xvjr4.execute-api.us-east-1.amazonaws.com/teams ✅
Get Matches https://jmde6xvjr4.execute-api.us-east-1.amazonaws.com/teams/matches ✅

### Documentation Requirements

• Create a README.md in the project's directory. ✅
• Add 2-3 GIFs to showcase your app UI and features. ✅
• Describe any particularly challenging technical issue you faced while working on theiOS project, how you approached solving it, and what you learned from the experience.Expectations• Simple, elegant, and malleable solutions. ✅
• Clean, readable, and organized code. ✅
• Knowledge of modern Apple APIs. ✅

## App Showcase

![](./docs/app1.gif)

![](./docs/app2.gif)

## Technical issues

### UI

- Build UI in UIKit programmatically is difficult. The code is long and hard to understand and maintain.
- Autolayout without the helps of IB is difficult to debug and fix bugs.
- UI optimization is time-consuming.

### CoreData

- When storing data fetched from server, we need to know when to discard offline data and fetch new data from server.
