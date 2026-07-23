# 🍔 Food Delivery

A Food Delivery iOS application built as part of a Senior iOS Developer assessment. The app demonstrates clean architecture, SwiftUI, asynchronous networking, local persistence, and responsive search functionality.

---

This project implements the following features:

- Home screen displaying restaurants fetched from a remote API
- Search restaurants by name with real-time filtering
- Restaurant details screen
- Favorite restaurants with persistent storage
- Loading, Empty, and Error states
- MVVM Architecture
- URLSession with async/await

The assignment requirements are available in the provided document. :contentReference[oaicite:0]{index=0}

---

# ✨ Features

### 🏠 Home Screen

- Fetch restaurants using URLSession
- Display:
  - Restaurant Name
  - Rating
  - Distance
  - Delivery Time
- Loading indicator
- Empty state
- Error handling

### 🔍 Search

- Search restaurants by name
- Real-time filtering while typing

### 🍽️ Restaurant Details

- Restaurant image
- Name
- Description
- Rating
- Distance
- Favorite button

### ❤️ Favorites

- Save favorite restaurants
- Persist data locally using SwiftData
- Favorites remain after app restart

---

# 🏛️ Architecture

The project follows the **MVVM (Model-View-ViewModel)** architecture to keep the code modular, testable, and maintainable.

```
Views
   │
   ▼
ViewModels
   │
   ▼
Services
   │
   ▼
Network Layer (URLSession)
```

### Model

Represents restaurant data and API response models using `Codable`.

### View

SwiftUI views responsible for displaying UI and handling user interactions.

### ViewModel

Contains business logic, state management, search functionality, and favorite handling while communicating with the service layer.

### Service

Handles all networking using `URLSession` and `async/await`, keeping API-related code separate from the UI.

---

# 🛠️ Technologies Used

- Swift 5
- SwiftUI
- MVVM Architecture
- URLSession
- async/await
- Codable
- SwiftData

---

# 📁 Project Structure

```
FoodDelivery
│
├── Models
├── Views
├── ViewModels
├── Services
├── Managers
├── Utilities
└── Resources
```

---

# 📋 Assumptions

The following assumptions were made during development:

- Restaurant data is fetched from the provided API.
- Dummy API data is mapped to restaurant information.
- If an image is unavailable, a placeholder image is displayed.
- Favorites are stored locally using SwiftData.
- Internet connectivity is required to fetch restaurant data.
- Authentication, payment, and order tracking are outside the scope of this assignment.

---

# ⚠️ Error Handling

The application gracefully handles:

- Loading state
- Empty state
- Network failures
- Invalid API responses
- No internet connection

---

# ⏱️ Time Spent

| Task | Time |
|------|------:|
| Project Setup | 10 min |
| Networking Layer | 25 min |
| Home Screen | 30 min |
| Search Feature | 30 min |
| Restaurant Details Screen | 20 min |
| Favorites Persistence | 20 min |
| UI Polish & Bug Fixes | 15 min |
| README & Documentation | 10 min |

**Total Time:** **2:40 Hours**

---

# 🚀 Future Improvements

Given more time, the following enhancements could be implemented:

- Unit Tests
- UI Tests
- Dependency Injection
- Image Caching
- Pagination
- Offline Support
- Repository Pattern

---

# ▶️ Running the Project

### Requirements

- Xcode 16+
- iOS 17+
- Swift 5.9+

### Installation

Clone the repository:

```bash
git clone https://github.com/sumesh0001/FoodDelivery.git
```

Open:

```text
FoodDelivery.xcodeproj
```

Run the project on a simulator or a physical device.

---

# 💡 Design Decisions

- Chose **SwiftUI** for a modern declarative UI.
- Used **MVVM** for clear separation of concerns.
- Implemented **async/await** for clean asynchronous networking.
- Used **UserDefaults** for lightweight favorite persistence, which satisfies the assignment requirements.
- Organized the project into reusable components for better scalability and maintainability.

---

# 👨‍💻 Author

**Sumesh Kumar**

Senior iOS Developer

GitHub: **https://github.com/sumesh0001**
