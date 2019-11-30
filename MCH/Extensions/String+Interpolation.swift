//
//  String+Interpolation.swift
//  MCH
//
//  Created by Akshay Gawade on 24/11/19.
//  Copyright © 2019 Akshay Gawade. All rights reserved.
//

import Foundation
import UIKit

struct AttrString {
    let attributedString: NSAttributedString
}

extension AttrString: ExpressibleByStringLiteral {
    init(stringLiteral: String) {
        self.attributedString = NSAttributedString(string: stringLiteral)
    }
}

extension AttrString: CustomStringConvertible {
    var description: String {
        return String(describing: self.attributedString)
    }
}

extension AttrString: ExpressibleByStringInterpolation {
    init(stringInterpolation: StringInterpolation) {
        self.attributedString = NSAttributedString(attributedString: stringInterpolation.attributedString)
    }
    
    struct StringInterpolation: StringInterpolationProtocol {
        var attributedString: NSMutableAttributedString
        
        init(literalCapacity: Int, interpolationCount: Int) {
            self.attributedString = NSMutableAttributedString()
        }
        
        func appendLiteral(_ literal: String) {
            let astr = NSAttributedString(string: literal)
            self.attributedString.append(astr)
        }
        
        func appendInterpolation(_ string: String, attributes: [NSAttributedString.Key: Any]) {
            let astr = NSAttributedString(string: string, attributes: attributes)
            self.attributedString.append(astr)
        }
    }
}

extension AttrString {
    struct Style {
        let attributes: [NSAttributedString.Key: Any]
        static func font(_ font: UIFont) -> Style {
            return Style(attributes: [.font: font])
        }
        static func fontMatrics(_ font: UIFont) -> Style {
            return Style(attributes: [.font: font])
        }

        static func lineSpacing(_ space: CGFloat) -> Style {
            let ps = NSMutableParagraphStyle()
            ps.lineSpacing = space
            return Style(attributes: [.paragraphStyle: ps])
        }
        static func color(_ color: UIColor) -> Style {
            return Style(attributes: [.foregroundColor: color])
        }
        static func bgColor(_ color: UIColor) -> Style {
            return Style(attributes: [.backgroundColor: color])
        }
        static func link(_ link: String) -> Style {
            return .link(URL(string: link)!)
        }
        static func link(_ link: URL) -> Style {
            return Style(attributes: [.link: link])
        }
        static let oblique = Style(attributes: [.obliqueness: 0.1])
        static func underline(_ color: UIColor, _ style: NSUnderlineStyle) -> Style {
            return Style(attributes: [
                .underlineColor: color,
                .underlineStyle: style.rawValue
                ])
        }
        static func alignment(_ alignment: NSTextAlignment) -> Style {
            let ps = NSMutableParagraphStyle()
            ps.alignment = alignment
            return Style(attributes: [.paragraphStyle: ps])
        }
    }
}

extension AttrString.StringInterpolation {
    func appendInterpolation(_ string: String, _ style: AttrString.Style) {
        let astr = NSAttributedString(string: string, attributes: style.attributes)
        self.attributedString.append(astr)
    }
    
    func appendInterpolation(_ string: String, _ style: AttrString.Style...) {
        var attrs: [NSAttributedString.Key: Any] = [:]
        style.forEach { attrs.merge($0.attributes, uniquingKeysWith: {$1}) }
        let astr = NSAttributedString(string: string, attributes: attrs)
        self.attributedString.append(astr)
    }
    func appendInterpolation(wrap string: AttrString, _ style: AttrString.Style...) {
        var attrs: [NSAttributedString.Key: Any] = [:]
        style.forEach { attrs.merge($0.attributes, uniquingKeysWith: {$1}) }
        let mas = NSMutableAttributedString(attributedString: string.attributedString)
        let fullRange = NSRange(mas.string.startIndex..<mas.string.endIndex, in: mas.string)
        mas.addAttributes(attrs, range: fullRange)
        self.attributedString.append(mas)
    }
}
