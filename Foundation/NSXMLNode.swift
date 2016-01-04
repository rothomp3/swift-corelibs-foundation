// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2015 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See http://swift.org/LICENSE.txt for license information
// See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//

import libxml2
/*!
    @typedef NSXMLNodeKind
*/
public enum NSXMLNodeKind : UInt {

    case InvalidKind
    case DocumentKind
    case ElementKind
    case AttributeKind
    case NamespaceKind
    case ProcessingInstructionKind
    case CommentKind
    case TextKind
    case DTDKind
    case EntityDeclarationKind
    case AttributeDeclarationKind
    case ElementDeclarationKind
    case NotationDeclarationKind
}

// initWithKind options
//  NSXMLNodeOptionsNone
//  NSXMLNodePreserveAll
//  NSXMLNodePreserveNamespaceOrder
//  NSXMLNodePreserveAttributeOrder
//  NSXMLNodePreserveEntities
//  NSXMLNodePreservePrefixes
//  NSXMLNodeIsCDATA
//  NSXMLNodeExpandEmptyElement
//  NSXMLNodeCompactEmptyElement
//  NSXMLNodeUseSingleQuotes
//  NSXMLNodeUseDoubleQuotes

// Output options
//  NSXMLNodePrettyPrint


/*!
    @class NSXMLNode
    @abstract The basic unit of an XML document.
*/
public class NSXMLNode : NSObject, NSCopying {
    

    public override func copy() -> AnyObject {
        return copyWithZone(nil)
    }

    public func copyWithZone(zone: NSZone) -> AnyObject {
        NSUnimplemented()
    }

    /*!
        @method initWithKind:
        @abstract Invokes @link initWithKind:options: @/link with options set to NSXMLNodeOptionsNone
    */
    public convenience init(kind: NSXMLNodeKind) {
        self.init(kind: kind, options: NSXMLNodeOptionsNone)
    }

    /*!
        @method initWithKind:options:
        @abstract Inits a node with fidelity options as description NSXMLNodeOptions.h
    */
    public init(kind: NSXMLNodeKind, options: Int) {

        self.kind = kind
        super.init()
    }

    /*!
        @method document:
        @abstract Returns an empty document.
    */
    public class func document() -> AnyObject {
        return NSXMLDocument(rootElement: nil)
    }

    /*!
        @method documentWithRootElement:
        @abstract Returns a document
        @param element The document's root node.
    */
    public class func documentWithRootElement(element: NSXMLElement) -> AnyObject {
        return NSXMLDocument(rootElement: element)
    }

    /*!
        @method elementWithName:
        @abstract Returns an element <tt>&lt;name>&lt;/name></tt>.
    */
    public class func elementWithName(name: String) -> AnyObject {
        return NSXMLElement(name: name)
    }

    /*!
        @method elementWithName:URI:
        @abstract Returns an element whose full QName is specified.
    */
    public class func elementWithName(name: String, URI: String) -> AnyObject {
        return NSXMLElement(name: name, URI: URI)
    }

    /*!
        @method elementWithName:stringValue:
        @abstract Returns an element with a single text node child <tt>&lt;name>string&lt;/name></tt>.
    */
    public class func elementWithName(name: String, stringValue string: String) -> AnyObject {
        return NSXMLElement(name: name, stringValue: string)
    }

    /*!
        @method elementWithName:children:attributes:
        @abstract Returns an element children and attributes <tt>&lt;name attr1="foo" attr2="bar">&lt;-- child1 -->child2&lt;/name></tt>.
    */
    public class func elementWithName(name: String, children: [NSXMLNode]?, attributes: [NSXMLNode]?) -> AnyObject {
        let element = NSXMLElement(name: name)
        element.setChildren(children)
        element.attributes = attributes

        return element
    }

    /*!
        @method attributeWithName:stringValue:
        @abstract Returns an attribute <tt>name="stringValue"</tt>.
    */
    public class func attributeWithName(name: String, stringValue: String) -> AnyObject {
        let result = NSXMLNode(kind: .AttributeKind)
        result.stringValue = stringValue
        result.name = name
        return result
    }

    /*!
        @method attributeWithLocalName:URI:stringValue:
        @abstract Returns an attribute whose full QName is specified.
    */
    public class func attributeWithName(name: String, URI: String, stringValue: String) -> AnyObject {
        let attribute = NSXMLNode.attributeWithName(name, stringValue: stringValue) as! NSXMLNode
        attribute.URI = URI

        return attribute
    }

    /*!
        @method namespaceWithName:stringValue:
        @abstract Returns a namespace <tt>xmlns:name="stringValue"</tt>.
    */
    public class func namespaceWithName(name: String, stringValue: String) -> AnyObject { NSUnimplemented() }

    /*!
        @method processingInstructionWithName:stringValue:
        @abstract Returns a processing instruction <tt>&lt;?name stringValue></tt>.
    */
    public class func processingInstructionWithName(name: String, stringValue: String) -> AnyObject {
        let result = NSXMLNode(kind: .ProcessingInstructionKind)
        result.stringValue = stringValue
        result.name = name
        return result
    }

    /*!
        @method commentWithStringValue:
        @abstract Returns a comment <tt>&lt;--stringValue--></tt>.
    */
    public class func commentWithStringValue(stringValue: String) -> AnyObject {
        let result = NSXMLNode(kind: .CommentKind)
        result.stringValue = stringValue
        return result
    }

    /*!
        @method textWithStringValue:
        @abstract Returns a text node.
    */
    public class func textWithStringValue(stringValue: String) -> AnyObject {
        let result = NSXMLNode(kind: .TextKind)
        result.stringValue = stringValue
        return result
    }

    /*!
        @method DTDNodeWithXMLString:
        @abstract Returns an element, attribute, entity, or notation DTD node based on the full XML string.
    */
    public class func DTDNodeWithXMLString(string: String) -> AnyObject? { NSUnimplemented() }

    /*!
        @method kind
        @abstract Returns an element, attribute, entity, or notation DTD node based on the full XML string.
    */
    public var kind: NSXMLNodeKind  //primitive

    /*!
        @method name
        @abstract Sets the nodes name. Applicable for element, attribute, namespace, processing-instruction, document type declaration, element declaration, attribute declaration, entity declaration, and notation declaration.
    */
    public var name: String? {
        get {
            return _name
        }
        set {
            switch kind {
            case .AttributeDeclarationKind:
                fallthrough
            case .AttributeKind:
                fallthrough
            case .ElementDeclarationKind:
                fallthrough
            case .ElementKind:
                fallthrough
            case .EntityDeclarationKind:
                fallthrough
            case .NamespaceKind:
                fallthrough
            case .NotationDeclarationKind:
                fallthrough
            case .ProcessingInstructionKind:
                _name = newValue

            default:
                break
            }
        }
    }

    private var _name: String? = nil
    /*!
        @method objectValue
        @abstract Sets the content of the node. Setting the objectValue removes all existing children including processing instructions and comments. Setting the object value on an element creates a single text node child.
    */
    public var objectValue: AnyObject? {

        willSet {

        }
    }//primitive

    /*!
        @method stringValue:
        @abstract Sets the content of the node. Setting the stringValue removes all existing children including processing instructions and comments. Setting the string value on an element creates a single text node child. The getter returns the string value of the node, which may be either its content or child text nodes, depending on the type of node. Elements are recursed and text nodes concatenated in document order with no intervening spaces.
    */
    public var stringValue: String? {
        get {
            if let value = objectValue as? CustomStringConvertible {
                return "\(value.description)"
            } else if let value = objectValue {
                return "\(value)"
            } else {
                return nil
            }
        }

        set {
            objectValue = newValue?._bridgeToObject()
        }
    }

    private func _removeAllChildNodesExceptAttributes() {
        for node in self {
            if node.kind != .AttributeKind {
                node.detach()
            }
        }
    }

    internal func _removeAllChildren() {
        for child in self {
            child.parent = nil
        }
        _firstChild = nil
        _lastChild = nil
    }

    /*!
        @method setStringValue:resolvingEntities:
        @abstract Sets the content as with @link setStringValue: @/link, but when "resolve" is true, character references, predefined entities and user entities available in the document's dtd are resolved. Entities not available in the dtd remain in their entity form.
    */
    public func setStringValue(string: String, resolvingEntities resolve: Bool) {
        guard resolve else {
            stringValue = string
            return
        }

        _removeAllChildNodesExceptAttributes()

        var entities: [(Range<Int>, String)] = []
        var entityChars: [Character] = []
        var inEntity = false
        var startIndex = 0
        for (index, char) in string.characters.enumerate() {
            if char == "&" {
                inEntity = true
                startIndex = index
                continue
            }
            if char == ";" && inEntity {
                inEntity = false
                entities.append((Range<Int>(start: startIndex, end: index + 1),String(entityChars)))
                startIndex = 0
                entityChars.removeAll()
            }
            if inEntity {
                entityChars.append(char)
            }
        }

        var result: [Character] = Array(string.characters)
//        for (range, entity) in entities {
//            var entityPtr = xmlGetDocEntity(_xmlNode.memory.doc, entity)
//            if entityPtr == nil {
//                entityPtr = xmlGetDtdEntity(_xmlNode.memory.doc, entity)
//            }
//            if entityPtr == nil {
//                entityPtr = xmlGetParameterEntity(_xmlNode.memory.doc, entity)
//            }
//            if entityPtr != nil {
//                let replacement = String.fromCString(UnsafePointer<CChar>(entityPtr.memory.content)) ?? ""
//                result.replaceRange(range, with: replacement.characters)
//            } else {
//                result.replaceRange(range, with: []) // This appears to be how Darwin Foundation does it
//            }
//        }
        stringValue = String(result)
    } //primitive

    /*!
        @method index
        @abstract A node's index amongst its siblings.
    */
    public var index: Int = -1 //primitive

    /*!
        @method level
        @abstract The depth of the node within the tree. Documents and standalone nodes are level 0.
    */
    public var level: Int {
        var result = 0
        var maybeParent = parent
        while maybeParent != nil {
            result += 1
            maybeParent = parent?.parent
        }

        return result
    }

    /*!
        @method rootDocument
        @abstract The encompassing document or nil.
    */
    public var rootDocument: NSXMLDocument?

    /*!
        @method parent
        @abstract The parent of this node. Documents and standalone Nodes have a nil parent; there is not a 1-to-1 relationship between parent and children, eg a namespace cannot be a child but has a parent element.
    */
    /*@NSCopying*/ public var parent: NSXMLNode?
     //primitive

    /*!
        @method childCount
        @abstract The amount of children, relevant for documents, elements, and document type declarations. Use this instead of [[self children] count].
    */
    public var childCount: Int = 0//primitive

    /*!
        @method children
        @abstract An immutable array of child nodes. Relevant for documents, elements, and document type declarations.
    */
    public var children: [NSXMLNode]? {
        switch kind {
        case .DocumentKind:
            fallthrough
        case .ElementKind:
            fallthrough
        case .DTDKind:
            return Array<NSXMLNode>(self as NSXMLNode)

        default:
            return nil
        }
    } //primitive

    private var _firstChild: NSXMLNode?
    private var _lastChild: NSXMLNode?

    /*!
        @method childAtIndex:
        @abstract Returns the child node at a particular index.
    */
    public func childAtIndex(index: Int) -> NSXMLNode? {
        precondition(index >= 0)
        precondition(index < childCount)

        var nodeIndex = startIndex
        for _ in 0..<index {
            nodeIndex = nodeIndex.successor()
        }

        return nodeIndex.node
    } //primitive

    /*!
        @method previousSibling:
        @abstract Returns the previous sibling, or nil if there isn't one.
    */
    /*@NSCopying*/ public var previousSibling: NSXMLNode?

    /*!
        @method nextSibling:
        @abstract Returns the next sibling, or nil if there isn't one.
    */
    /*@NSCopying*/ public var nextSibling: NSXMLNode?

    /*!
        @method previousNode:
        @abstract Returns the previous node in document order. This can be used to walk the tree backwards.
    */
    /*@NSCopying*/ public var previousNode: NSXMLNode? {
        if let previousSibling = self.previousSibling {
            if let result = previousSibling._lastChild {
                return result
            } else {
                return previousSibling
            }
        } else if let parent = self.parent {
            return parent
        } else {
            return nil
        }
    }

    /*!
        @method nextNode:
        @abstract Returns the next node in document order. This can be used to walk the tree forwards.
    */
    /*@NSCopying*/ public var nextNode: NSXMLNode? {
        if let first = _firstChild {
            return first
        } else if let next = nextSibling {
            return next
        } else if let parent = self.parent {
            return parent.nextSibling
        } else {
            return nil
        }
    }

    /*!
        @method detach:
        @abstract Detaches this node from its parent.
    */
    public func detach() {
        parent?._removeNode(self)
    } //primitive

    private func _removeNode(node: NSXMLNode) {
        guard node.parent == self else { return }
        _removeChildAtIndex(node.index)
    }
    /*!
        @method XPath
        @abstract Returns the XPath to this node, for example foo/bar[2]/baz.
    */
    public var XPath: String? {
        guard rootDocument != nil else { return nil }

        var pathComponents: [String?] = []
        if let parent = parent  {
            let siblingsWithSameName = parent.filter { $0.name == self.name }

            if siblingsWithSameName.count > 1 {
                guard let index = siblingsWithSameName.indexOf(self) else { return nil }

                pathComponents.append("\(self.name ?? "")[\(index + 1)]")
            } else {
                pathComponents.append(self.name)
            }
        } else {
            return self.name
        }

        var maybeParent = parent
        while true {
            if let grandparent = maybeParent?.parent {
                let possibleParentNodes = grandparent.filter { $0.name == self.parent?.name }
                let count = possibleParentNodes.reduce(0) {
                    return $0.0 + 1
                }

                if count <= 1 {
                    pathComponents.append(maybeParent?.name)
                } else {
                    var parentNumber = 1
                    for possibleParent in possibleParentNodes {
                        if possibleParent == self.parent {
                            break
                        }
                        parentNumber += 1
                    }

                    pathComponents.append("\(self.parent?.name ?? "")[\(parentNumber)]")
                }

                maybeParent = maybeParent?.parent

            } else {
                pathComponents.append(maybeParent?.name)
                break
            }
        }

        return pathComponents.reverse().flatMap({ return $0 }).joinWithSeparator("/")
    }

    /*!
    	@method localName
    	@abstract Returns the local name bar if this attribute or element's name is foo:bar
    */
    public var localName: String? {
        if let name = self.name {
            let nameParts = name.characters.split(":")
            return String(nameParts.last)
        }

        return nil
    } //primitive

    /*!
    	@method prefix
    	@abstract Returns the prefix foo if this attribute or element's name if foo:bar
    */
    public var prefix: String? {
        if let name = self.name {
            let nameParts = name.characters.split(":")
            return String(nameParts.last)
        }

        return nil
    } //primitive

    /*!
    	@method URI
    	@abstract Set the URI of this element, attribute, or document. For documents it is the URI of document origin. Getter returns the URI of this element, attribute, or document. For documents it is the URI of document origin and is automatically set when using initWithContentsOfURL.
    */
    public var URI: String?  //primitive

    /*!
        @method localNameForName:
        @abstract Returns the local name bar in foo:bar.
     */
    public class func localNameForName(name: String) -> String {
        return name.withCString {
            var length: Int32 = 0
            let result = xmlSplitQName3(UnsafePointer<xmlChar>($0), &length)
            return String.fromCString(UnsafePointer<CChar>(result)) ?? ""
        }
    }

    /*!
        @method localNameForName:
        @abstract Returns the prefix foo in the name foo:bar.
    */
    public class func prefixForName(name: String) -> String? {
        return name.withCString {
            var result: UnsafeMutablePointer<xmlChar> = nil
            let unused = xmlSplitQName2(UnsafePointer<xmlChar>($0), &result)
            defer {
                xmlFree(result)
                xmlFree(UnsafeMutablePointer<xmlChar>(unused))
            }
            return String.fromCString(UnsafePointer<CChar>(result))
        }
    }

    /*!
        @method predefinedNamespaceForPrefix:
        @abstract Returns the namespace belonging to one of the predefined namespaces xml, xs, or xsi
    */
    public class func predefinedNamespaceForPrefix(name: String) -> NSXMLNode? { NSUnimplemented() }

    /*!
        @method description
        @abstract Used for debugging. May give more information than XMLString.
    */
    public override var description: String {
        return XMLString
    }

    /*!
        @method XMLString
        @abstract The representation of this node as it would appear in an XML document.
    */
    public var XMLString: String {
        return XMLStringWithOptions(NSXMLNodeOptionsNone)
    }

    /*!
        @method XMLStringWithOptions:
        @abstract The representation of this node as it would appear in an XML document, with various output options available.
    */
    public func XMLStringWithOptions(options: Int) -> String {

        let elements = self.filter({ $0.kind == .ElementKind })
        let attributes = self.filter({ $0.kind == .AttributeKind })
        let name = self.name ?? ""
        var result = "<\(name)"
        for attribute in attributes {
            result += " \(attribute.name ?? "")=\"\(attribute.stringValue ?? "")\""
        }
        result += ">"
        result += stringValue ?? ""
        for element in elements {
            result += element.XMLStringWithOptions(options)
        }

        result += "</\(name)>"
        return result
    }

    /*!
        @method canonicalXMLStringPreservingComments:
        @abstract W3 canonical form (http://www.w3.org/TR/xml-c14n). The input option NSXMLNodePreserveWhitespace should be set for true canonical form.
    */
    public func canonicalXMLStringPreservingComments(comments: Bool) -> String { NSUnimplemented() }

    /*!
        @method nodesForXPath:error:
        @abstract Returns the nodes resulting from applying an XPath to this node using the node as the context item ("."). normalizeAdjacentTextNodesPreservingCDATA:NO should be called if there are adjacent text nodes since they are not allowed under the XPath/XQuery Data Model.
    	@returns An array whose elements are a kind of NSXMLNode.
    */
    public func nodesForXPath(xpath: String) throws -> [NSXMLNode] {
        NSUnimplemented()
    }

    /*!
        @method objectsForXQuery:constants:error:
        @abstract Returns the objects resulting from applying an XQuery to this node using the node as the context item ("."). Constants are a name-value dictionary for constants declared "external" in the query. normalizeAdjacentTextNodesPreservingCDATA:NO should be called if there are adjacent text nodes since they are not allowed under the XPath/XQuery Data Model.
    	@returns An array whose elements are kinds of NSArray, NSData, NSDate, NSNumber, NSString, NSURL, or NSXMLNode.
    */
    public func objectsForXQuery(xquery: String, constants: [String : AnyObject]?) throws -> [AnyObject] { NSUnimplemented() }

    public func objectsForXQuery(xquery: String) throws -> [AnyObject] { NSUnimplemented() }

//    internal var _childNodes: Set<NSXMLNode> = []
//
//    internal init(ptr: xmlNodePtr) {
//        precondition(ptr != nil)
//        precondition(ptr.memory._private == nil, "Only one NSXMLNode per xmlNodePtr allowed")
//
//        _xmlNode = ptr
//        self.kind = .InvalidKind
//        super.init()
//
//        let parent = _xmlNode.memory.parent
//        if parent != nil {
//            let parentNode = NSXMLNode._objectNodeForNode(parent)
//            parentNode._childNodes.insert(self)
//        }
//
//        let unmanaged = Unmanaged<NSXMLNode>.passUnretained(self)
//        _xmlNode.memory._private = UnsafeMutablePointer<Void>(unmanaged.toOpaque())
//    }
//
//    internal class func _objectNodeForNode(node: xmlNodePtr) -> NSXMLNode {
//        switch node.memory.type {
//        case XML_ELEMENT_NODE:
//            return NSXMLElement._objectNodeForNode(node)
//
//        case XML_DOCUMENT_NODE:
//            return NSXMLDocument._objectNodeForNode(node)
//
//        case XML_DTD_NODE:
//            return NSXMLDTD._objectNodeForNode(node)
//
//        default:
//            if node.memory._private != nil {
//                let unmanaged = Unmanaged<NSXMLNode>.fromOpaque(node.memory._private)
//                return unmanaged.takeUnretainedValue()
//            }
//
//            return NSXMLNode(ptr: node)
//        }
//    }

    // libxml2 believes any node can have children, though NSXMLNode disagrees.
    // Nevertheless, this belongs here so that NSXMLElement and NSXMLDocument can share
    // the same implementation.
    internal func _insertChild(child: NSXMLNode, atIndex index: Int) {
        precondition(index >= 0)
        precondition(index <= childCount)
        precondition(child.parent == nil)

        if index < childCount {
            var prevChild = _firstChild
            let nextChild: NSXMLNode?
            if index > 0 {
                for _ in 0..<(index - 1) {
                    prevChild = prevChild?.nextSibling
                }
                nextChild = prevChild?.nextSibling
            } else {
                prevChild = nil
                nextChild = _firstChild
                _firstChild = child
            }

            child.previousSibling = prevChild
            child.nextSibling = nextChild
            prevChild?.nextSibling = child
            nextChild?.previousSibling = child

            if nextChild == nil {
                _lastChild = child
            } else {
                var childToUpdate = nextChild
                while childToUpdate != nil {
                    childToUpdate?.index += 1
                    childToUpdate = childToUpdate?.nextSibling
                }
            }
        } else {
            if let last = _lastChild {
                _lastChild = child
                last.nextSibling = child
                child.previousSibling = last
                child.nextSibling = nil
            } else {
                _firstChild = child
                _lastChild = child
                child.nextSibling = nil
                child.previousSibling = nil
            }
        }

        childCount += 1

        child.parent = self
        child.index = index
    } //primitive
    
    // see above
    internal func _insertChildren(children: [NSXMLNode], atIndex index: Int) {
        for (childIndex, node) in children.enumerate() {
            _insertChild(node, atIndex: index + childIndex)
        }
    }

    /*!
     @method removeChildAtIndex:atIndex:
     @abstract Removes a child at a particular index.
     */
    // See above!
    internal func _removeChildAtIndex(index: Int) {
        guard let child = childAtIndex(index) else {
            fatalError("index out of bounds")
        }

        if index == 0 {
            _firstChild = child.nextSibling
        }

        if index == (childCount - 1) {
            _lastChild = child.previousSibling
        }

        let next = child.nextSibling
        let prev = child.previousSibling

        next?.previousSibling = prev
        prev?.nextSibling = next

        child.nextSibling = nil
        child.previousSibling = nil
        child.parent = nil

        childCount -= 1
        child.index = -1

        var childToUpdate = next
        while childToUpdate != nil {
            childToUpdate?.index -= 1
            childToUpdate = childToUpdate?.nextSibling
        }
    } //primitive

    // see above
    internal func _setChildren(children: [NSXMLNode]?) {
        _removeAllChildren()
        guard let children = children else {
            return
        }

        for child in children {
            _addChild(child)
        }
    } //primitive

    /*!
     @method addChild:
     @abstract Adds a child to the end of the existing children.
     */
    // see above
    internal func _addChild(child: NSXMLNode) {
        _insertChild(child, atIndex: childCount)
    }

    /*!
     @method replaceChildAtIndex:withNode:
     @abstract Replaces a child at a particular index with another child.
     */
    // see above
    internal func _replaceChildAtIndex(index: Int, withNode node: NSXMLNode) {
        precondition(index < childCount)
        precondition(index >= 0)

        let child = childAtIndex(index)!

        node.nextSibling = child.nextSibling
        node.previousSibling = child.previousSibling
        node.parent = self
        node.index = index

        if _lastChild == child {
            _lastChild = node
        }

        if _firstChild == child {
            _firstChild = node
        }

        child.previousSibling?.nextSibling = node
        child.nextSibling?.previousSibling = node

        child.parent = nil
        child.previousSibling = nil
        child.nextSibling = nil
        child.index = -1
    }
}

extension NSXMLNode: CollectionType {
    public struct Index: BidirectionalIndexType {
        private let node: NSXMLNode?
        private let parent: NSXMLNode

        public func predecessor() -> Index {
            guard node != nil else { return Index(node: parent._lastChild, parent: parent) }
            return Index(node: node?.previousSibling, parent: parent)
        }

        public func successor() -> Index {
            guard node != nil else { return parent.startIndex }
            return Index(node: node?.nextSibling, parent: parent)
        }
    }

    public subscript(index: Index) -> NSXMLNode {
        return index.node!
    }

    public var startIndex: Index {
        return Index(node: _firstChild, parent: self)
    }

    public var endIndex: Index {
        return Index(node: nil, parent: self)
    }
}

public func ==(lhs: NSXMLNode.Index, rhs: NSXMLNode.Index) -> Bool {
    return lhs.node === rhs.node && lhs.parent === rhs.parent
}
