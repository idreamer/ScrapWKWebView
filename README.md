# ScrapWKWebView

This package provides a seamless integration of the WKWebView within a SwiftUI View, enabling dynamic web page scraping. By passing a URL to the associated scraping function within the View, the desired data can be extracted effectively.


## How to use
```
        ScrapWKWebView(url: "https://google.com", timeout: 2.0) { html in
            // Write your own logic to extract a data from the raw html
            // SwiftSoup could be a way to easily do it
        }
```
