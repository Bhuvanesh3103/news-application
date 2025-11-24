# Flutter News Aggregator App

A simple cross-platform news application built with **Flutter**, **GetX**, and **NewsAPI**.  
Users can browse category-wise news, read full articles, and save items for offline access.

---

##  Architecture Overview

The project follows a **feature-oriented architecture** with clean separation between:

### **1. Presentation Layer**
- Screens (Home, Detail, Saved, Preferences)
- UI widgets
- SliverAppBar & responsive layout components

### **2. Controller Layer (GetX)**
- `NewsController` → fetches category news
- `SavedController` → manages saved articles
- Uses reactive variables (`Rx`) for UI updates
- Dependency injection via `Get.put()` and `Get.find()`

### **3. Data Layer**
- `NewsService` → API calls (NewsAPI Everything endpoint)
- `LocalStorage` → persistent storage (GetStorage)
- `Article` model → unified JSON mapping for API + saved data

This structure keeps:
- UI clean and stateless
- Logic centralized
- Code easy to extend (pagination, dark mode, etc.)

---

## Design Decisions

### ** GetX for State Management**
Chosen for:
- Lightweight syntax (`obs`, `Obx`)
- Built-in routing + dependency injection
- Minimal boilerplate compared to Provider/Bloc

### **✔ GetStorage for Offline Saving**
- Simple key-value storage
- Fast + persistent
- Perfect for saving small data (bookmarks)

### App Screenshots

- Home Screen:
![Home Screen](./lib/screenshots/home-screen.png)

- Detail Screen:
![Detail Screen](./lib/screenshots/detail-screen.png)
