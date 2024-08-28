# Mini Challenge 3 - Team 12
## Overview
This repository contains the source code for the Reminder App, which integrates with a watch to send notifications, allows users to create checklists for reminders, and set reminders based on location (radius-based) or time (repeat or once).

## Tech Decision
`UIKit` - `PushKit` - `MapKit` - `SwiftData` - `CloudKit`

## Folder Structure
- `Models` - Define the Data Model
- `ViewModels` - Contain Business Logic and Data Manipulation
- `Views` - UI to display to the users
- `Services` - Contain Services to managing and handling notification also Manage location updates and monitoring
- `Utilities` - Contain Utilities
- `Extensions` - Contain Extensions
- `Managers` - Coordinates between service and viewmodels

## Git WorkFlow
### Branching Strategy
1. Create new branch named = **feature/xxx**, Each new feature should be developed in its own feature branch, named `feature/xxx` where `xxx` is a short description of the feature
2. Make sure your branch up to date with the main branch
3. Test your code before push !

### How to push
1. Clone the project from main branch
2. Create and checkout with feature name you want to create
3. Before making a pull request make sure your branch up to date with the main branch
4. After Push and make PR contact team member to notif them that you have create PR
5. The rest team member have to review the code created
6. After all the member have review the code then merge to main branch
