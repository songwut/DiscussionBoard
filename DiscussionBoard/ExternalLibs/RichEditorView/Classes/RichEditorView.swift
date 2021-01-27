//
//  RichEditor.swift
//
//  Created by Caesar Wirth on 4/1/15.
//  Copyright (c) 2015 Caesar Wirth. All rights reserved.
//

import UIKit
import WebKit

public class EditorWebView: WKWebView {
    

    var accessoryView: UIView?

    public override var inputAccessoryView: UIView? {
        // remove/replace the default accessory view
        return accessoryView
    }
}

/// RichEditorDelegate defines callbacks for the delegate of the RichEditorView
@objc public protocol RichEditorDelegate: class {

    /// Called when the inner height of the text being displayed changes
    /// Can be used to update the UI
    @objc optional func richEditor(_ editor: RichEditorView, heightDidChange height: Int)

    /// Called whenever the content inside the view changes
    @objc optional func richEditor(_ editor: RichEditorView, contentDidChange content: String)

    /// Called when the rich editor starts editing
    @objc optional func richEditorTookFocus(_ editor: RichEditorView)
    
    /// Called when the rich editor stops editing or loses focus
    @objc optional func richEditorLostFocus(_ editor: RichEditorView)
    
    /// Called when the RichEditorView has become ready to receive input
    /// More concretely, is called when the internal UIWebView loads for the first time, and contentHTML is set
    @objc optional func richEditorDidLoad(_ editor: RichEditorView)
    
    /// Called when the internal UIWebView begins loading a URL that it does not know how to respond to
    /// For example, if there is an external link, and then the user taps it
    @objc optional func richEditor(_ editor: RichEditorView, shouldInteractWith url: URL) -> Bool
    
    /// Called when custom actions are called by callbacks in the JS
    /// By default, this method is not used unless called by some custom JS that you add
    @objc optional func richEditor(_ editor: RichEditorView, handle action: String)
}

/// RichEditorView is a UIView that displays richly styled text, and allows it to be edited in a WYSIWYG fashion.
@objcMembers open class RichEditorView: UIView, UIScrollViewDelegate, UIGestureRecognizerDelegate, WKNavigationDelegate, WKUIDelegate {

    // MARK: Public Properties

    /// The delegate that will receive callbacks when certain actions are completed.
    open weak var delegate: RichEditorDelegate?

    /// Input accessory view to display over they keyboard.
    /// Defaults to nil
    open override var inputAccessoryView: UIView? {
        get { return webView.accessoryView }
        set { webView.accessoryView = newValue }
    }

    /// The internal UIWebView that is used to display the text.
    open private(set) var webView: EditorWebView

    /// Whether or not scroll is enabled on the view.
    open var isScrollEnabled: Bool = true {
        didSet {
            webView.scrollView.isScrollEnabled = isScrollEnabled
        }
    }

    /// Whether or not to allow user input in the view.
    open func getIsEditingEnabled(complete: @escaping(_ edit: Bool) -> ()) {
        getIsContentEditable { (edit) in
            complete(edit)
        }
    }
    var isEditingEnabled = true {
        didSet {
            setIsContentEditable(self.isEditingEnabled)
        }
    }
    /*
    open var isEditingEnabled: Bool {
        get { return isContentEditable }
        set { isContentEditable = newValue }
    }
    */

    /// The content HTML of the text being displayed.
    /// Is continually updated as the text is being edited.
    open private(set) var contentHTML: String = "" {
        didSet {
            delegate?.richEditor?(self, contentDidChange: contentHTML)
        }
    }

    /// The internal height of the text being displayed.
    /// Is continually being updated as the text is edited.
    open private(set) var editorHeight: Int = 0 {
        didSet {
            delegate?.richEditor?(self, heightDidChange: editorHeight)
        }
    }

    /// The value we hold in order to be able to set the line height before the JS completely loads.
    private var innerLineHeight: Int = 28

    /// The line height of the editor. Defaults to 28.
    public func setLineHeight(_ newValue: Int) {
        innerLineHeight = newValue
        runJS("RE.setLineHeight('\(innerLineHeight)px');") { (string) in
            
        }
    }
    
    public func getLineHeight(complete: @escaping (_ h: Int) -> ()) {
        runJS("RE.getLineHeight();") { (string) in
            if self.isEditorLoaded, let lineHeight = Int(string) {
                complete(lineHeight)
            } else {
                complete(self.innerLineHeight)
            }
        }
    }
    public func getLineHeightAndCaretY(complete: @escaping (_ h: Int) -> ()) {
        runJS("RE.getLineHeight();") { (string) in
            if self.isEditorLoaded, let lineHeight = Int(string) {
                complete(lineHeight)
            } else {
                complete(self.innerLineHeight)
            }
        }
    }

    // MARK: Private Properties

    /// Whether or not the editor has finished loading or not yet.
    private var isEditorLoaded = false

    /// Value that stores whether or not the content should be editable when the editor is loaded.
    /// Is basically `isEditingEnabled` before the editor is loaded.
    private var editingEnabledVar = true

    /// The private internal tap gesture recognizer used to detect taps and focus the editor
    private let tapRecognizer = UITapGestureRecognizer()

    /// The inner height of the editor div.
    /// Fetches it from JS every time, so might be slow!
    func getClientHeight(complete: @escaping (_ h:Int) -> ()) {
        runJS("document.getElementById('editor').clientHeight;") { (string) in
            complete(Int(string) ?? 0)
        }
    }

    // MARK: Initialization
    
    public override init(frame: CGRect) {
        self.webViewCofig.dataDetectorTypes = .all
        self.webViewCofig.preferences = WKPreferences()
        self.webViewCofig.preferences.javaScriptEnabled = true
        webView = EditorWebView(frame: frame, configuration: self.webViewCofig)
        super.init(frame: frame)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        webView = EditorWebView()
        self.webViewCofig.dataDetectorTypes = .all
        self.webViewCofig.preferences = WKPreferences()
        self.webViewCofig.preferences.javaScriptEnabled = true
        //webView.configuration = self.webViewCofig
        super.init(coder: aDecoder)
        setup()
    }
    
    private let webViewCofig = WKWebViewConfiguration()
    
    
    private func setup() {
        backgroundColor = .red
        self.webViewCofig.dataDetectorTypes = .all
        self.webViewCofig.preferences = WKPreferences()
        self.webViewCofig.preferences.javaScriptEnabled = true
        webView = EditorWebView(frame: bounds, configuration: self.webViewCofig)
        webView.frame = bounds
        webView.uiDelegate = self
        //webView.navigationDelegate = self
        webView.keyboardDisplayRequiresUserAction = false
        //<meta name="viewport" content="width=device-width, shrink-to-fit=YES">
        //webView.scalesPageToFit = false
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.backgroundColor = .white
        
        webView.scrollView.isScrollEnabled = isScrollEnabled
        webView.scrollView.bounces = false
        webView.scrollView.delegate = self
        webView.scrollView.clipsToBounds = false
        
        self.inputAccessoryView = nil
        
        self.addSubview(webView)
        //let bundle = Bundle(for: RichEditorView.self)
        let bundle = Bundle.main
        if let filePath = bundle.path(forResource: "rich_editor", ofType: "html") {
            let url = URL(fileURLWithPath: filePath, isDirectory: false)
            var request = URLRequest(url: url)
            let cookies = HTTPCookieStorage.shared.cookies ?? [HTTPCookie]()
            let headerFields = HTTPCookie.requestHeaderFields(with: cookies)
            request.allHTTPHeaderFields = headerFields
        }

        tapRecognizer.addTarget(self, action: #selector(viewWasTapped))
        tapRecognizer.delegate = self
        addGestureRecognizer(tapRecognizer)
    }

    // MARK: - Rich Text Editing

    // MARK: Properties

    /// The HTML that is currently loaded in the editor view, if it is loaded. If it has not been loaded yet, it is the
    /// HTML that will be loaded into the editor view once it finishes initializing.
    
    func getHtml(complete: @escaping (_ html: String) -> ()) {
        runJS("RE.getHtml();") { (string) in
            self.html = string
            complete(string)
        }
    }
    var html = "" {
        didSet {
            contentHTML = self.html
            if isEditorLoaded {
                runJS("RE.setHtml('\(self.html.escaped)');") { (string) in
                    
                }
                updateHeight()
            }
        }
    }

    /// Text representation of the data that has been input into the editor view, if it has been loaded.
    func getText(complete: @escaping (_ string: String) -> ()) {
        runJS("RE.getText()") { (string) in
            complete(string)
        }
    }

    /// Private variable that holds the placeholder text, so you can set the placeholder before the editor loads.
    private var placeholderText: String = ""
    /// The placeholder text that should be shown when there is no user input.
    open var placeholder: String {
        get { return placeholderText }
        set {
            placeholderText = newValue
            runJS("RE.setPlaceholderText('\(newValue.escaped)');") { (string) in
                
            }
        }
    }


    /// The href of the current selection, if the current selection's parent is an anchor tag.
    /// Will be nil if there is no href, or it is an empty string.
    func getSelectedHref(complete: @escaping (_ str: String?) -> ()) {
        getHasRangeSelection { (hasRangeSelection) in
            if !hasRangeSelection { complete(nil) }
            self.runJS("RE.getSelectedHref();") { (href) in
                if href == "" {
                    complete(nil)
                } else {
                    complete(href)
                }
            }
        }
    }

    /// Whether or not the selection has a type specifically of "Range".
    func getHasRangeSelection(complete: @escaping (_ has: Bool) -> ()) {
        runJS("RE.rangeSelectionExists();") { (string) in
            complete(string == "true")
        }
    }

    /// Whether or not the selection has a type specifically of "Range" or "Caret".
    
    func getHasRangeOrCaretSelectio(complete: @escaping (_ has: Bool) -> ()) {
        runJS("RE.rangeOrCaretSelectionExists();") { (string) in
            complete(string == "true")
        }
    }

    // MARK: Methods

    public func removeFormat() {
        runJS("RE.removeFormat();") { (string) in
            
        }
    }
    
    public func setFontSize(_ size: Int) {
        runJS("RE.setFontSize('\(size)px');") { (string) in
            
        }
    }
    
    public func setEditorBackgroundColor(_ color: UIColor) {
        runJS("RE.setBackgroundColor('\(color.hex)');") { (string) in
            
        }
    }
    
    public func undo() {
        runJS("RE.undo();") { (string) in
            
        }
    }
    
    public func redo() {
        runJS("RE.redo();") { (string) in
            
        }
    }
    
    public func bold() {
        runJS("RE.setBold();") { (string) in
            
        }
    }
    
    public func italic() {
        runJS("RE.setItalic();") { (string) in
            
        }
    }
    
    // "superscript" is a keyword
    public func subscriptText() {
        runJS("RE.setSubscript();") { (string) in
            
        }
    }
    
    public func superscript() {
        runJS("RE.setSuperscript();") { (string) in
            
        }
    }
    
    public func strikethrough() {
        runJS("RE.setStrikeThrough();") { (string) in
            
        }
    }
    
    public func underline() {
        runJS("RE.setUnderline();") { (string) in
            
        }
    }
    
    public func setTextColor(_ color: UIColor) {
        runJS("RE.prepareInsert();") { (string) in
            
        }
        runJS("RE.setTextColor('\(color.hex)');") { (string) in
            
        }
    }
    
    public func setEditorFontColor(_ color: UIColor) {
        runJS("RE.setBaseTextColor('\(color.hex)');") { (string) in
            
        }
    }
    
    public func setTextBackgroundColor(_ color: UIColor) {
        runJS("RE.prepareInsert();") { (string) in
            
        }
        runJS("RE.setTextBackgroundColor('\(color.hex)');") { (string) in
            
        }
    }
    
    public func header(_ h: Int) {
        runJS("RE.setHeading('\(h)');") { (string) in
            
        }
    }

    public func indent() {
        runJS("RE.setIndent();") { (string) in
            
        }
    }

    public func outdent() {
        runJS("RE.setOutdent();") { (string) in
            
        }
    }

    public func orderedList() {
        runJS("RE.setOrderedList();") { (string) in
            
        }
    }

    public func unorderedList() {
        runJS("RE.setUnorderedList();") { (string) in
            
        }
    }

    public func blockquote() {
        runJS("RE.setBlockquote()") { (string) in
            
        }
    }
    
    public func alignLeft() {
        runJS("RE.setJustifyLeft();") { (string) in
            
        }
    }
    
    public func alignCenter() {
        runJS("RE.setJustifyCenter();") { (string) in
            
        }
    }
    
    public func alignRight() {
        runJS("RE.setJustifyRight();") { (string) in
            
        }
    }
    
    public func insertImage(_ url: String, alt: String) {
        runJS("RE.prepareInsert();") { (string) in
            
        }
        runJS("RE.insertImage('\(url.escaped)', '\(alt.escaped)');") { (string) in
            
        }
    }
    
    public func insertLink(_ href: String, title: String) {
        runJS("RE.prepareInsert();") { (string) in
            
        }
        runJS("RE.insertLink('\(href.escaped)', '\(title.escaped)');") { (string) in
            
        }
    }
    
    public func focus() {
        runJS("RE.focus();") { (string) in
            
        }
    }

    public func focus(at: CGPoint) {
        runJS("RE.focusAtPoint(\(at.x), \(at.y));") { (string) in
            
        }
    }
    
    public func blur() {
        runJS("RE.blurFocus()") { (string) in
            
        }
    }

    /// Runs some JavaScript on the UIWebView and returns the result
    /// If there is no result, returns an empty string
    /// - parameter js: The JavaScript string to be run
    /// - returns: The result of the JavaScript that was run
    
    public func runJS(_ js: String, complete: @escaping (_ result:String) -> ()) {
        webView.evaluateJavaScript(js) { (result, error) in
            if let string = result as? String {
                complete(string)
            }
        }
    }
    /*
    public func runJS(_ js: String) -> String {
        //TODO: test
        let string = webView.stringByEvaluatingJavaScript(from:js) ?? ""
        //return string
    }
*/

    // MARK: - Delegate Methods


    // MARK: UIScrollViewDelegate

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // We use this to keep the scroll view from changing its offset when the keyboard comes up
        if !isScrollEnabled {
            scrollView.bounds = webView.bounds
        }
    }

    //MARK:- WKNavigationDelegate
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        var action = WKNavigationActionPolicy.allow
        guard let url = navigationAction.request.url else { return }
        print("decidePolicyFor - url: \(url)")
        let callbackPrefix = "re-callback://"
        if url.absoluteString.hasPrefix(callbackPrefix) == true {
            
            // When we get a callback, we need to fetch the command queue to run the commands
            // It comes in as a JSON array of commands that we need to parse
            runJS("RE.getCommandQueue();") { (commands) in
                if let data = commands.data(using: .utf8) {
                    
                    let jsonCommands: [String]
                    do {
                        jsonCommands = try JSONSerialization.jsonObject(with: data) as? [String] ?? []
                    } catch {
                        jsonCommands = []
                        NSLog("RichEditorView: Failed to parse JSON Commands")
                    }
                    
                    jsonCommands.forEach(self.performCommand)
                }
            }
            action = .cancel
        }
        // User is tapping on a link, so we should react accordingly
        if navigationAction.navigationType == .linkActivated {
            let shouldInteract = delegate?.richEditor?(self, shouldInteractWith: url) ?? false
            if shouldInteract {
                action = .cancel
                UIApplication.shared.open(url, options: [:])
            }
        }
        decisionHandler(action)
    }

    // MARK: UIGestureRecognizerDelegate

    /// Delegate method for our UITapGestureDelegate.
    /// Since the internal web view also has gesture recognizers, we have to make sure that we actually receive our taps.
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }


    // MARK: - Private Implementation Details
    
    func getIsContentEditable(complete: @escaping (_ i: Bool) -> ()) {
        if isEditorLoaded {
            runJS("RE.editor.isContentEditable") { (value) in
                self.editingEnabledVar = Bool(value) ?? false
                complete(self.editingEnabledVar)
            }
        }
    }
    func setIsContentEditable(_ newValue:Bool) {
        editingEnabledVar = newValue
        if isEditorLoaded {
            let value = newValue ? "true" : "false"
            runJS("RE.editor.contentEditable = \(value);") { (string) in
                
            }
        }
    }
    
    /// The position of the caret relative to the currently shown content.
    /// For example, if the cursor is directly at the top of what is visible, it will return 0.
    /// This also means that it will be negative if it is above what is currently visible.
    /// Can also return 0 if some sort of error occurs between JS and here.
    
    func getRelativeCaretYPosition(complete: @escaping(_ i: Int) -> ()) {
        runJS("RE.getRelativeCaretYPosition();") { (string) in
            complete(Int(string) ?? 0)
        }
    }

    private func updateHeight() {
        runJS("document.getElementById('editor').clientHeight;") { [self] (heightString) in
            let height = Int(heightString) ?? 0
            if self.editorHeight != height {
                self.editorHeight = height
            }
        }
    }

    /// Scrolls the editor to a position where the caret is visible.
    /// Called repeatedly to make sure the caret is always visible when inputting text.
    /// Works only if the `lineHeight` of the editor is available.
    private func scrollCaretToVisible() {
        let scrollView = self.webView.scrollView
        
        self.getClientHeight { (clientHeight) in
            let contentHeight = clientHeight > 0 ? CGFloat(clientHeight) : scrollView.frame.height
            scrollView.contentSize = CGSize(width: scrollView.frame.width, height: contentHeight)
            
            // XXX: Maybe find a better way to get the cursor height
            self.getLineHeight { (lineHeight) in
                let lineHeight = CGFloat(lineHeight)
                let cursorHeight = lineHeight - 4
                
                self.getRelativeCaretYPosition { (relativeCaretYPosition) in
                    let visiblePosition = CGFloat(relativeCaretYPosition)
                    var offset: CGPoint?

                    if visiblePosition + cursorHeight > scrollView.bounds.size.height {
                        // Visible caret position goes further than our bounds
                        offset = CGPoint(x: 0, y: (visiblePosition + lineHeight) - scrollView.bounds.height + scrollView.contentOffset.y)

                    } else if visiblePosition < 0 {
                        // Visible caret position is above what is currently visible
                        var amount = scrollView.contentOffset.y + visiblePosition
                        amount = amount < 0 ? 0 : amount
                        offset = CGPoint(x: scrollView.contentOffset.x, y: amount)

                    }

                    if let offset = offset {
                        scrollView.setContentOffset(offset, animated: true)
                    }
                }
                
            }
        }
    }
    
    /// Called when actions are received from JavaScript
    /// - parameter method: String with the name of the method and optional parameters that were passed in
    private func performCommand(_ method: String) {
        if method.hasPrefix("ready") {
            // If loading for the first time, we have to set the content HTML to be displayed
            if !isEditorLoaded {
                isEditorLoaded = true
                html = contentHTML
                setIsContentEditable(editingEnabledVar)
                placeholder = placeholderText
                setLineHeight(innerLineHeight)
                delegate?.richEditorDidLoad?(self)
            }
            updateHeight()
        }
        else if method.hasPrefix("input") {
            scrollCaretToVisible()
            runJS("RE.getHtml()") { (content) in
                self.contentHTML = content
            }
            updateHeight()
        }
        else if method.hasPrefix("updateHeight") {
            updateHeight()
        }
        else if method.hasPrefix("focus") {
            delegate?.richEditorTookFocus?(self)
        }
        else if method.hasPrefix("blur") {
            delegate?.richEditorLostFocus?(self)
        }
        else if method.hasPrefix("action/") {
            runJS("RE.getHtml()") { (content) in
                self.contentHTML = content
            }
            
            // If there are any custom actions being called
            // We need to tell the delegate about it
            let actionPrefix = "action/"
            let range = method.range(of: actionPrefix)!
            let action = method.replacingCharacters(in: range, with: "")
            delegate?.richEditor?(self, handle: action)
        }
    }

    // MARK: - Responder Handling

    /// Called by the UITapGestureRecognizer when the user taps the view.
    /// If we are not already the first responder, focus the editor.
    @objc private func viewWasTapped() {
        if !webView.containsFirstResponder {
            let point = tapRecognizer.location(in: webView)
            focus(at: point)
        }
    }

    override open func becomeFirstResponder() -> Bool {
        if !webView.containsFirstResponder {
            focus()
            return true
        } else {
            return false
        }
    }

    open override func resignFirstResponder() -> Bool {
        blur()
        return true
    }

}
