# BookStore

See new releases and search for programming books from [IT Bookstore API](https://api.itbook.store)

This is a sample app to practice using `Result` type, stubbing network request for unit tests, separating functionalities into frameworks, and writing Swift documentation.

### How to run

```
> cd BookStore
> open BookStore.xcodeproj
```

Run!

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


