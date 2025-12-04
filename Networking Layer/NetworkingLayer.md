## Networking Layer Guide (Beginner Friendly)

### 1. Goal of This Networking Layer

- **Reuse the same code for all API calls**
- **Keep views (UI) clean**
- **Support GET / POST / PUT / DELETE**
- **Have logging, error handling, and interceptors in one place**

We do this using **MVVM**:

- **View**: SwiftUI screen (`ContentView`, `HomePage`, etc.)
- **ViewModel**: Handles API calls (`ProductViewModel`, `HomePageViewModel`, etc.)
- **Service**: Reusable network helper (`APIService`)

---

### 2. Steps to Use `APIService` in `HomePage.swift`

1. Create a new file `HomePageViewModel.swift` (you can choose your own name).
2. Import `SwiftUI` in `HomePageViewModel.swift`.
3. Create a class `HomePageViewModel: ObservableObject`.
4. Inside it, add `@Published var products: [Product] = []`.
5. Inside it, add `private let api = APIService.shared`.
6. Add a function `func loadProducts()` in `HomePageViewModel`.
7. Inside `loadProducts()`, call `api.get(url: APIEndpoint.products.url) { result in ... }`.
8. In the success case, decode `data` to `[Product]` and assign to `self.products` on the main thread.
9. In the failure case, print or store the `error`.
10. Create a new file `HomePage.swift`.
11. Import `SwiftUI` in `HomePage.swift`.
12. Create `struct HomePage: View`.
13. Inside it, add `@StateObject private var viewModel = HomePageViewModel()`.
14. In the `body`, create a `List(viewModel.products) { product in Text(product.title) }`.
15. Add `.onAppear { viewModel.loadProducts() }` to the main view in `body`.

---

### 3. Simple GET / POST / PUT / DELETE Usage

- **GET (read data)**  
  Use when you only want to fetch data:
  - `api.get(url: APIEndpoint.products.url) { result in ... }`

- **POST (create / send data)**  
  Use when you want to send new data (for example, a new product):
  1. Make a JSON body with `JSONEncoder()`.
  2. Call  
     `api.post(url: APIEndpoint.products.url, headers: ["Content-Type": "application/json"], body: body) { result in ... }`

- **PUT (update data)**  
  Use when you want to update existing data:
  - Similar to POST, but call  
    `api.put(url: APIEndpoint.products.url, headers: ["Content-Type": "application/json"], body: body) { result in ... }`

- **DELETE (delete data)**  
  Use when you want to delete something:
  - `api.delete(url: APIEndpoint.products.url) { result in ... }`
