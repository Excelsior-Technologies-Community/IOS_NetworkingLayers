
# # 🚀 iOS Networking Layer — Swift Networking Made Simple

A reusable, modular, and scalable **Networking Layer** built using **Swift**, compatible with **MVC** and **MVVM** architecture.
This package provides:

* A generic **API Handler**
* Support for **GET / POST / PUT / DELETE**
* Built-in **Logging**
* Built-in **Error Handling**
* Optional **Interceptors** (Auth token, headers, etc.)
* Fully testable with **dummy API responses**
* Super easy-to-use for beginners and teams

---

# ## 📦 Installation — Add as Swift Package Dependency

### **Step 1: Open Xcode → File → Add Package Dependency**

### **Step 2: Paste this URL**

```
https://github.com/Excelsior-Technologies-Community/excelsior-Technologies-Community-IOS_NetworkingLayers.git
```

### **Step 3: Choose Version Rule**

→ Recommended: **Up To Next Major (Semantic Versioning)**

### **Step 4: Select Your App Target & Finish**

### **Step 5: Import it in your Swift file**

```swift
IOSNetworkingLayers
```

You're ready to use it 🎉

---

# ## 🧱 Project Structure

```
NetworkingLayers/
│
├── Package.swift
├── Sources/
│   └── NetworkingLayers/
│       ├── APIService.swift
│       ├── APIEndpoint.swift
│       ├── APIError.swift
│       ├── Logger.swift
│       ├── Interceptor.swift
│       └── DummyData.swift
└── Tests/
```

---

# ## 🧩 Features Overview

### ✔ **Reusable API Handler**

A single handler that performs all HTTP requests.

### ✔ **Supports GET / POST / PUT / DELETE**

All major HTTP methods supported.

### ✔ **Logging**

Logs:

* URL
* Method
* Status Codes
* Body

### ✔ **Error Handling**

Handles:

* No Internet
* Invalid Response
* Server Errors
* Decoding Errors

### ✔ **Interceptors**

Manipulate requests before sending them:

* Add Authorization Token
* Add Custom Headers
* Refresh expired token

---

# ## 📘 How to Use (Step-by-Step)

---

# ### 1️⃣ Define Your Endpoint

Every API endpoint goes in **APIEndpoint.swift**:

```swift
enum APIEndpoint {
    case products
    case login

    var url: URL {
        switch self {
        case .products:
            return URL(string: "https://jsonplaceholder.typicode.com/posts")!
        case .login:
            return URL(string: "https://reqres.in/api/login")!
        }
    }

    var method: HTTPMethod {
        switch self {
        case .products: return .get
        case .login: return .post
        }
    }
}
```

---

# ### 2️⃣ Call API using APIService

### **GET Request Example**

```swift
APIService.shared.request(endpoint: .products) { result in
    switch result {
    case .success(let data):
        let products = try? JSONDecoder().decode([Product].self, from: data)
        print(products ?? [])
    case .failure(let error):
        print("Error:", error.localizedDescription)
    }
}
```

---

### **POST Request Example**

```swift
let body = ["email": "noman@test.com", "password": "123456"]

APIService.shared.request(endpoint: .login, body: body) { result in
    switch result {
    case .success(let data):
        print("Logged in!")
    case .failure(let error):
        print("Login Failed:", error.localizedDescription)
    }
}
```

---

# ### 3️⃣ Using the Networking Layer in MVVM

### **ViewModel**

```swift
class ProductViewModel: ObservableObject {
    @Published var products: [Product] = []

    func loadProducts() {
        APIService.shared.request(endpoint: .products) { result in
            switch result {
            case .success(let data):
                if let decoded = try? JSONDecoder().decode([Product].self, from: data) {
                    DispatchQueue.main.async {
                        self.products = decoded
                    }
                }
            case .failure(let error):
                print("Error:", error.localizedDescription)
            }
        }
    }
}
```

---

### **SwiftUI View**

```swift
struct ProductScreen: View {
    @StateObject var vm = ProductViewModel()

    var body: some View {
        List(vm.products) { product in
            Text(product.title)
        }
        .onAppear {
            vm.loadProducts()
        }
    }
}
```

---

# ### 4️⃣ Using Networking Layer in MVC

### **ViewController**

```swift
class ProductController: UIViewController {

    var products: [Product] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        APIService.shared.request(endpoint: .products) { result in
            switch result {
            case .success(let data):
                self.products = (try? JSONDecoder().decode([Product].self, from: data)) ?? []
            case .failure(let error):
                print("Error:", error.localizedDescription)
            }
        }
    }
}
```

---

# ## 🧪 Dummy API Support (No backend required)

Developers can test without real server:

```swift
let data = DummyData.products
let decoded = try? JSONDecoder().decode([Product].self, from: data)
```

---

# ## 🛠 Interceptors (Optional)

Interceptors run BEFORE the request is sent.

Examples:

* Add Auth Token
* Add Headers
* Modify request body

```swift
Interceptor.shared.addAuthToken("token_123")

Interceptor.shared.setHeader("App-Version", value: "1.0.0")
```

The APIService applies these automatically.

---

# ## 🐞 Error Handling

Your APIError covers:

| Error                  | Meaning               |
| ---------------------- | --------------------- |
| `.noInternet`          | No network connection |
| `.serverError(status)` | Backend error         |
| `.invalidResponse`     | Response corrupted    |
| `.decodeError`         | JSON decoding failed  |

Use in UI:

```swift
.catch { error in showToast(error.localizedDescription) }
```

---

# ## 📝 Logging

All logs printed automatically:

```
🌐 GET: https://dummy.com/products
📥 Status Code: 200
📦 Response Size: 230 bytes
```

---

# ## ❤️ Contribution

Pull Requests & Issues welcome!

---

# ## 📄 License

MIT License.

---

# ✅ Done!
 
