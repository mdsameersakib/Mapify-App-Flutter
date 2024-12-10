# 📍 **Mapify: Geographic Entity Viewer**

Mapify is a mobile application that allows users to view, create, edit, and delete geographic entities (latitude, longitude, title, and image) on a map centered on **Bangladesh**. The app integrates with a RESTful API to manage these entities and uses **OpenStreetMap** (via `flutter_map`) for mapping.

---

## 🚀 **Features**

- **View Map with Entity Markers:** Visualize entities on a map centered on Bangladesh.  
- **CRUD Operations:**  
  - **Create Entity:** Add new geographic entities with title, latitude, longitude, and image.  
  - **Edit Entity:** Update existing entity information.  
  - **Delete Entity:** Remove entities from the system.  
- **Entity List View:** View all entities in a list with edit/delete options.  
- **Offline Handling & Error Alerts:** Handle API errors gracefully and provide feedback.

---

## 🛠️ **Tech Stack**

- **Flutter**: Cross-platform mobile application development framework.  
- **OpenStreetMap**: Interactive mapping with `flutter_map`.  
- **RESTful API**: Connects with `https://labs.anontech.info/cse489/t3/api.php`.  
- **HTTP Requests**: Handled using `http` package.  

---

## 📥 **Setup Instructions**

1. Clone this repository:
   ```bash
   git clone <repository-url>
   ```
2. Navigate to the project directory:
   ```bash
   cd mapify
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the application:
   ```bash
   flutter run
   ```

---

## 🔗 **API Endpoints**

The app interacts with the following RESTful endpoints:

- **Create Entity**  
  URL: `POST /api.php`  
  Required Params: `title`, `lat`, `lon`, `image`.  

- **Retrieve Entities**  
  URL: `GET /api.php`  

- **Update Entity**  
  URL: `PUT /api.php`  
  Params: `id`, `title`, `lat`, `lon`, `image`.  

- **Delete Entity**  
  URL: `DELETE /api.php?id=<entity-id>`

---

## 🏆 **Contributing**

Contributions are welcome! Please fork the repository, make your changes, and submit a pull request.

---
