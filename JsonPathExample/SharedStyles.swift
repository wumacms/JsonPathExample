import SwiftUI

/// 共享的 UI 样式和常量，用于保持应用程序的一致性
enum SharedStyles {
    // MARK: - Colors
    
    /// 主要操作按钮颜色
    static let primaryButtonColor = Color.blue
    
    /// 危险操作按钮颜色
    static let dangerButtonColor = Color.red
    
    /// 边框颜色
    static let borderColor = Color.gray.opacity(0.3)
    
    // MARK: - Spacing
    
    /// 标准间距
    static let standardSpacing: CGFloat = 20
    
    /// 小间距
    static let smallSpacing: CGFloat = 4
    
    /// 内边距
    static let standardPadding: CGFloat = 8
    
    // MARK: - Corner Radius
    
    /// 标准圆角半径
    static let cornerRadius: CGFloat = 8
    
    // MARK: - Border Width
    
    /// 标准边框宽度
    static let borderWidth: CGFloat = 1
}

// MARK: - View Modifiers

/// 为文本编辑器和滚动视图提供一致的样式
struct CodeEditorStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color(nsColor: .textBackgroundColor))
            .cornerRadius(SharedStyles.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: SharedStyles.cornerRadius)
                    .stroke(SharedStyles.borderColor, lineWidth: SharedStyles.borderWidth)
            )
    }
}

/// 为按钮提供主要样式
struct PrimaryButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(SharedStyles.primaryButtonColor)
            .foregroundColor(.white)
            .cornerRadius(SharedStyles.cornerRadius)
    }
}

// MARK: - View Extensions

extension View {
    /// 应用代码编辑器样式
    func codeEditorStyle() -> some View {
        modifier(CodeEditorStyle())
    }
    
    /// 应用主要按钮样式
    func primaryButtonStyle() -> some View {
        modifier(PrimaryButtonStyle())
    }
}

// MARK: - Sample Data

/// 共享的示例 JSON 数据
enum SampleJSON {
    /// 书店示例数据
    static let bookstore = """
    {
        "store": {
            "book": [
                {
                    "category": "reference",
                    "author": "Nigel Rees",
                    "title": "Sayings of the Century",
                    "display-price": 8.95,
                    "bargain": true
                },
                {
                    "category": "fiction",
                    "author": "Evelyn Waugh",
                    "title": "Sword of Honour",
                    "display-price": 12.99,
                    "bargain": false
                },
                {
                    "category": "fiction",
                    "author": "Herman Melville",
                    "title": "Moby Dick",
                    "isbn": "0-553-21311-3",
                    "display-price": 8.99,
                    "bargain": true
                },
                {
                    "category": "fiction",
                    "author": "J. R. R. Tolkien",
                    "title": "The Lord of the Rings",
                    "isbn": "0-395-19395-8",
                    "display-price": 22.99,
                    "bargain": false
                }
            ],
            "bicycle": {
                "color": "red",
                "display-price": 19.95,
                "foo:bar": "fooBar",
                "dot.notation": "new",
                "dash-notation": "dashes"
            }
        }
    }
    """
    
    /// 人员示例数据
    static let people = """
    {
        "data": {
            "people": [
                {
                    "name": "Rocco",
                    "age": 42,
                    "gender": "m"
                },
                {
                    "name": "John",
                    "age": 12,
                    "gender": "m"
                },
                {
                    "name": "Elizabeth",
                    "age": 35,
                    "gender": "f"
                },
                {
                    "name": "Victoria",
                    "age": 85,
                    "gender": "f"
                }
            ]
        }
    }
    """
}
