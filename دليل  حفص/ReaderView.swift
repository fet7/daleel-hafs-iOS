//
//  ReaderView.swift
//  دليل  حفص
//
//  Created by Feysel on 15/07/2026.
//


import SwiftUI
import WebKit

struct ReaderView: UIViewRepresentable {
    let fileName: String
    @Environment(\.colorScheme) var colorScheme

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        context.coordinator.onPageFinished = { [weak webView] in
            guard let webView = webView else { return }
            applyColorScheme(to: webView)
        }
        if let url = Bundle.main.url(forResource: fileName, withExtension: "html") {
            webView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        }
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let currentURL = uiView.url,
           currentURL.deletingPathExtension().lastPathComponent == fileName {
            applyColorScheme(to: uiView)
            return
        }
        if let url = Bundle.main.url(forResource: fileName, withExtension: "html") {
            uiView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
        }
    }

    private func applyColorScheme(to webView: WKWebView) {
        let css: String
        if colorScheme == .dark {
            css = """
            body { background-color: #1c1c1e !important; color: #e5e5e5 !important; }
            h1, h2, h3, h4 { color: #4db6ac !important; }
            p, ul, ol, td, th { color: #d1d1d1 !important; }
            a:link, a:visited, a:active { color: #6eb5ff !important; }
            .myDiv { border-color: #888 !important; }
            .myTitles { color: #ccc !important; border-color: #888 !important; }
            table tr:nth-child(even) { background-color: #2a2a2a !important; }
            table tr:nth-child(odd) { background-color: #1e1e1e !important; }
            table th { background-color: #2e5a56 !important; }
            table#t01 td { background-color: #1e1e1e !important; border-color: #555 !important; }
            table#t02 th { border-color: #4db6ac !important; color: #4db6ac !important; background-color: #1e1e1e !important; }
            table#t02 td { background-color: #1e1e1e !important; }
            """
        } else {
            css = """
            body { background-color: white !important; color: black !important; }
            h1, h2, h3, h4 { color: #008577 !important; }
            p, ul, ol, td, th { color: black !important; }
            a:link, a:visited, a:active { color: blue !important; }
            .myDiv { border-color: #555 !important; }
            .myTitles { color: black !important; border-color: #555 !important; }
            table tr:nth-child(even) { background-color: #E9FCEC !important; }
            table tr:nth-child(odd) { background-color: #fff !important; }
            table th { background-color: #008577 !important; }
            table#t01 td { background-color: white !important; border-color: black !important; }
            table#t02 th { border-color: #008577 !important; color: #008577 !important; background-color: white !important; }
            table#t02 td { background-color: white !important; }
            """
        }
        let js = """
        var style = document.getElementById('dark-mode-style');
        if (!style) {
            style = document.createElement('style');
            style.id = 'dark-mode-style';
            document.head.appendChild(style);
        }
        style.innerHTML = `\(css)`;
        """
        webView.evaluateJavaScript(js, completionHandler: nil)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var onPageFinished: (() -> Void)?

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            onPageFinished?()
        }
    }
}
