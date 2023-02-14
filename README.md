# Bulb
# Overview

This **iOS application** provides a simple solution for those who need a little help in taking care of their house plants. It is based on **MVVM architecture** and uses **Firebase** as backend infrastructure and storage. The UI is built using **UIKit** components. The main functionality is coved by **unit tests**. 

# Functionality

The mobile application is composed of 3 main flows with some key features:
* Onboarding - Authentication flow
    - Sign in 
* Tasks 
    - Display today’s tasks and the upcoming ones
    - Actions: snooze, skip or complete a task
    - Show tasks’ details screen 
    - Log out
* Plants 
    - Search by name and filter by category
    - Show plant’s details
    - Add plant to favourites

# Technical perspective

* Business Logic
    - Creating services for managing the Firebase’s requests queries. Data decoupling from the external API using **Data Transfer Object**.
    - Implementing View Models for each View Controller to separate responsibilities
    - Using dependency injection for decoupling logic and increased testability
* UI
    - Implementing reusable and configurable custom views 
    - Using **UITableView** and **UICollectionView**
* Testing
    - Behaviour driven testing using **Quick** and **Nimble**
    - Using test doubles as mocks and stubs
