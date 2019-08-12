# BookStore

See new releases and search for programming books from [IT Bookstore API](https://api.itbook.store)

This is a sample app to practice using `Result` type, stubbing network request for unit tests, separating functionalities into frameworks, and writing Swift documentation.

### How to run

```
> cd BookStore
> open BookStore.xcodeproj
```

Run!

## App Features

### What's New

A simple `UITableView` with cells and modal presentation for a detailed page.

### Search

1. As a user types in the keyword, the search text is "debounced" for a fraction of second for better performance and user experience. See [Debouncer](https://github.com/nsoojin/BookStore/blob/3a3e91f903e5a77ebdcafd53803fd3edad0dde65/BookStoreKit/Utils/Debouncer.swift#L11).

2. Search results are paginated and provides infinite scroll

## Contents

- [`Result` type in Swift 5](https://github.com/nsoojin/BookStore#result-type-in-swift-5)

- [Stubbing Network Requests for Unit Tests](https://github.com/nsoojin/BookStore#stubbing-network-requests-for-unit-tests)

- [Using Frameworks for independent functionalities](https://github.com/nsoojin/BookStore#using-frameworks-for-independent-functionalities)

- [Writing a documentation comment](https://github.com/nsoojin/BookStore#writing-a-documentation-comment)

## `Result` type in Swift 5

Out of the box, you have to switch on the `Result` instance to access the underlying success instance or the error instance. 

```Swift
switch result {
case .success(let response):
  //do something with the response
case .failure(let error):
  //handle error
}
```

However, I think switch statements are too wordy. I added [`success`](https://github.com/nsoojin/BookStore/blob/5f3d7d85503fd1de51d04b0286653a3578a7125a/BookStore/Extensions/Result%20%2B%20Extensions.swift#L25) and [`catch`](https://github.com/nsoojin/BookStore/blob/5f3d7d85503fd1de51d04b0286653a3578a7125a/BookStore/Extensions/Result%20%2B%20Extensions.swift#L34) method to `Result` type. So it can be chained like this.

```Swift
searchResult.success { response in
  //do something with the response
}.catch { error in
  //handle error
}
```

Even cleaner, like this.

```Swift
result.success(handleSuccess)
      .catch(handleError)
      
func handleSuccess(_ result: SearchResult) { ... }
func handleError(_ error: Error) { ... }
```

## Stubbing Network Requests for Unit Tests

Generally, it is not a good idea to rely on the actual network requests for unit tests because it adds too much dependency on tests. One way to stub networking is to subclass `URLProtocol`.

### 1. Subclass `URLProtocol`

See [`MockURLProtocol`](https://github.com/nsoojin/BookStore/blob/master/BookStoreKitTests/MockAPI/MockURLProtocol.swift)

### 2. Configure `URLSession` with your mock `URLProtocol`

```Swift
let config = URLSessionConfiguration.ephemeral
config.protocolClasses = [MockURLProtocol.self]

//Use this URLSession instance to make requests.
let session = URLSession(configuration: config) 
```

### 4. Use the configured `URLSession` instance just as you would.

```Swift
session.dataTask(with: urlRequest) { (data, response, error) in
  //Stubbed response
}.resume()
```

## Using Frameworks for independent functionalities

Separating your app's functions into targets has several advantages. It forces you to care about dependencies, and it is good for unit tests since features are sandboxed. However, it may slow down the app launch (by little) due to framework loading.

`BookStoreKit` is responsible for fetching and searching books data from [IT Bookstore API](https://api.itbook.store). 

`Networking` is a wrapper around URLSession for making HTTP requests and parsing response.

<img src="https://raw.githubusercontent.com/nsoojin/BookStore/master/README_assets/xcodeproj-targets.png" width="200">

## Writing a documentation comment

[Swift's API Design Guidelines](https://swift.org/documentation/api-design-guidelines/#fundamentals) suggest you write a documentation comment for every declaration. Writing one can have an impact on the design.

### 1. Write

Reference this [document](https://developer.apple.com/library/archive/documentation/Xcode/Reference/xcode_markup_formatting_ref/index.html) for markup formatting.

<img src="https://raw.githubusercontent.com/nsoojin/BookStore/master/README_assets/documentation-0.png">

### 2. Check out the result

In Xcode's autocompletion

<img src="https://raw.githubusercontent.com/nsoojin/BookStore/master/README_assets/documentation-1.png" width="400">

and Show Quick Help (option + click)

<img src="https://raw.githubusercontent.com/nsoojin/BookStore/master/README_assets/documentation-2.png" width="600">
