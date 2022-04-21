//
//  WebView.swift
//  StockAPP
//
//  Created by 叶科呈 on 4/20/22.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let fileName: String
    let fileDirectory: String
    let JSONData: String
    
    init(fileName: String, fileDirectory: String, JSONData: String) {
        self.fileName = fileName
        self.fileDirectory = fileDirectory
        self.JSONData = JSONData
    }

    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        var webView: WKWebView?
        let JSONData: String

        init(JSONData: String) {
            self.JSONData = JSONData
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            self.webView = webView
            self.messageToWebview(msg: self.JSONData)
        }

        // receive message from wkwebview
        func userContentController(
            _ userContentController: WKUserContentController,
            didReceive message: WKScriptMessage
        ) {
            print(message.body)
        }

        func messageToWebview(msg: String) {
            self.webView?.evaluateJavaScript("webkit.messageHandlers.bridge.onMessage('\(msg)')")
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(JSONData: JSONData)
    }

    func makeUIView(context: Context) -> WKWebView {
        let coordinator = makeCoordinator()
        let userContentController = WKUserContentController()
        userContentController.add(coordinator, name: "bridge")

        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController

        let _wkwebview = WKWebView(frame: .zero, configuration: configuration)
        _wkwebview.navigationDelegate = coordinator

        return _wkwebview
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        guard let path: String = Bundle.main.path(forResource: fileName, ofType: "html", inDirectory: fileDirectory) else { return }
        let localHTMLUrl = URL(fileURLWithPath: path, isDirectory: false)
        webView.loadFileURL(localHTMLUrl, allowingReadAccessTo: localHTMLUrl)
    }
}

//struct WebView: UIViewRepresentable {
//    let fileName: String
//    let fileDirectory: String
//
//    init(fileName: String, fileDirectory: String) {
//        self.fileName = fileName
//        self.fileDirectory = fileDirectory
//    }
//
//    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
//        var webView: WKWebView?
//        let JSONData: String
//
//        init(JSONData: String) {
//            self.JSONData = JSONData
//        }
//
//        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//            self.webView = webView
//            self.messageToWebview(msg: self.JSONData)
//        }
//
//        // receive message from wkwebview
//        func userContentController(
//            _ userContentController: WKUserContentController,
//            didReceive message: WKScriptMessage
//        ) {
//            print(message.body)
//        }
//
//        func messageToWebview(msg: String) {
//            self.webView?.evaluateJavaScript("webkit.messageHandlers.bridge.onMessage('\(msg)')")
//        }
//    }
//
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(JSONData: dataToJSON())
//    }
//
//    func makeUIView(context: Context) -> WKWebView {
//        let coordinator = makeCoordinator()
//        let userContentController = WKUserContentController()
//        userContentController.add(coordinator, name: "bridge")
//
//        let configuration = WKWebViewConfiguration()
//        configuration.userContentController = userContentController
//
//        let _wkwebview = WKWebView(frame: .zero, configuration: configuration)
//        _wkwebview.navigationDelegate = coordinator
//
//        return _wkwebview
//    }
//
//    func updateUIView(_ webView: WKWebView, context: Context) {
//        guard let path: String = Bundle.main.path(forResource: fileName, ofType: "html", inDirectory: fileDirectory) else { return }
//        let localHTMLUrl = URL(fileURLWithPath: path, isDirectory: false)
//        webView.loadFileURL(localHTMLUrl, allowingReadAccessTo: localHTMLUrl)
//    }
//
//    func dataToJSON() -> String {
//        return ""
//    }
//}
