 
#  **NetworkingLayer — Simple Swift Networking for GET/POST**

A lightweight Swift networking package that allows developers to call APIs in just **one line**, using:

* `SimpleAPI` (super easy)
* `APIService` (advanced control)

This package supports:

✔ GET
✔ POST
✔ PUT
✔ DELETE
✔ Error Handling
✔ Logging
✔ Clean, reusable architecture

---

#  **Installation (Swift Package Manager)**

1. Open Xcode → **File → Add Packages…**
2. Paste the repo URL:

```
https://github.com/Excelsior-Technologies-Community/excelsior-Technologies-Community-IOS_NetworkingLayers.git
```

3. Add to your project
4. Import the package:

```swift
import NetworkingLayer
```

You're ready to call APIs 🎉

---

# 📘 **How to Use (Examples for ContentView.swift)**

Below are the **only examples developers need** to use this package inside their SwiftUI project.

---

# ⚡ **1️⃣ Simple GET Request (Super Easy)**

```swift
import SwiftUI
import NetworkingLayer

struct ContentView: View {

    var body: some View {
        VStack {
            Button("Test GET API") {
                testGetAPI()
            }
            .padding()
        }
    }

    func testGetAPI() {
        SimpleAPI.call(
            url: "https://jsonplaceholder.typicode.com/posts",
            method: .get
        ) { result in

            switch result {
            case .success(let data):
                print("API Response:")
                print(String(data: data, encoding: .utf8)!)

            case .failure(let error):
                print("API Error:", error.description)
            }
        }
    }
}

#Preview {
    ContentView()
}
```

---

# ⚡ **2️⃣ Simple POST Request**

```swift
SimpleAPI.call(
    url: "https://reqres.in/api/login",
    method: .post,
    body: [
        "email": "user@test.com",
        "password": "123456"
    ]
) { result in
    switch result {
    case .success(let data):
        print(String(data: data, encoding: .utf8)!)
    case .failure(let error):
        print(error.description)
    }
}
```

---

# 🔥 **3️⃣ Advanced GET Using APIService**

```swift
APIService.shared.get(
    url: URL(string: "https://jsonplaceholder.typicode.com/posts")!
) { result in

    switch result {
    case .success(let data):
        print(String(data: data, encoding: .utf8)!)

    case .failure(let error):
        print("API Error:", error.description)
    }
}
```

---

# 🔥 **4️⃣ Advanced POST Using APIService**

```swift
APIService.shared.post(
    url: URL(string: "https://reqres.in/api/login")!,
    body: [
        "email": "test@mail.com",
        "password": "12345"
    ]
) { result in
    print(result)
}
```

---

# 🧪 **5️⃣ Decode JSON into Model Example**

Create your model:

```swift
struct Post: Codable, Identifiable {
    let id: Int
    let title: String
}
```

Call API & decode:

```swift
APIService.shared.get(
    url: URL(string: "https://jsonplaceholder.typicode.com/posts")!
) { result in
    switch result {
    case .success(let data):
        let posts = try? JSONDecoder().decode([Post].self, from: data)
        print(posts ?? [])

    case .failure(let error):
        print(error.description)
    }
}
```
 