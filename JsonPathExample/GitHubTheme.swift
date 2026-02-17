import SwiftUI

/// GitHub 主题风格的颜色和常量
enum GitHubTheme {
    // MARK: - Colors (GitHub Dark Theme Style)
    
    static let bgDefault = Color(hex: "0d1117") // 主背景
    static let bgSubtle = Color(hex: "161b22") // 侧边栏/次级背景
    static let bgInset = Color(hex: "010409") // 输入框/代码块背景
    
    static let borderDefault = Color(hex: "30363d") // 默认边框
    static let borderMuted = Color(hex: "21262d") // 弱化边框
    
    static let fgDefault = Color(hex: "c9d1d9") // 默认文字
    static let fgMuted = Color(hex: "8b949e") // 弱化文字
    static let fgAccent = Color(hex: "58a6ff") // 链接/强调文字 (Blue)
    static let fgSuccess = Color(hex: "3fb950") // 成功文字 (Green)
    static let fgDanger = Color(hex: "f85149") // 危险文字 (Red)
    
    static let btnBg = Color(hex: "21262d") // 按钮背景
    static let btnHoverBg = Color(hex: "30363d") // 按钮悬停背景
    static let btnPrimaryBg = Color(hex: "238636") // 主要按钮背景 (Green)
    static let btnPrimaryHoverBg = Color(hex: "2ea043") // 主要按钮悬停
    
    // MARK: - Dimensions
    
    static let cornerRadius: CGFloat = 6
    static let padding: CGFloat = 16
    static let smallPadding: CGFloat = 8
    static let borderWidth: CGFloat = 1
}

// MARK: - Hex Color Helper
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Components

/// GitHub 风格的卡片容器
struct GHCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(GitHubTheme.padding)
            .background(GitHubTheme.bgSubtle)
            .cornerRadius(GitHubTheme.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: GitHubTheme.cornerRadius)
                    .stroke(GitHubTheme.borderDefault, lineWidth: GitHubTheme.borderWidth)
            )
    }
}

/// GitHub 风格的代码/输入框
struct GHCodeEditor: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(.body, design: .monospaced))
            .padding(GitHubTheme.smallPadding)
            .background(GitHubTheme.bgInset)
            .cornerRadius(GitHubTheme.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: GitHubTheme.cornerRadius)
                    .stroke(GitHubTheme.borderDefault, lineWidth: GitHubTheme.borderWidth)
            )
    }
}

/// GitHub 风格的按钮
struct GHButtonStyle: ButtonStyle {
    var isPrimary: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(isPrimary ? GitHubTheme.btnPrimaryBg : GitHubTheme.btnBg)
            .foregroundColor(.white)
            .cornerRadius(GitHubTheme.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: GitHubTheme.cornerRadius)
                    .stroke(isPrimary ? Color.clear : GitHubTheme.borderDefault, lineWidth: GitHubTheme.borderWidth)
            )
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
    }
}

extension View {
    func ghCodeStyle() -> some View {
        modifier(GHCodeEditor())
    }
}
