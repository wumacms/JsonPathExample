import SwiftUI

struct PathGeneratorView: View {
    @StateObject private var viewModel = PathViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: GitHubTheme.padding) {
            headerView
            
            HSplitView {
                GHCard {
                    VStack(alignment: .leading) {
                        Label("源 JSON 数据", systemImage: "doc.text.fill")
                            .font(.subheadline.bold())
                            .foregroundColor(GitHubTheme.fgMuted)
                        
                        TextEditor(text: $viewModel.jsonString)
                            .ghCodeStyle()
                    }
                }
                .frame(minWidth: 300)
                
                GHCard {
                    VStack(alignment: .leading) {
                        HStack {
                            Label("解析出的节点 (\(viewModel.paths.count))", systemImage: "point.3.connected.trianglepath.dotted")
                                .font(.subheadline.bold())
                                .foregroundColor(GitHubTheme.fgMuted)
                            Spacer()
                            Button("复制全部") { copyAllPaths() }
                                .buttonStyle(GHButtonStyle())
                                .disabled(viewModel.paths.isEmpty)
                                .font(.caption)
                        }
                        
                        ScrollView {
                            VStack(alignment: .leading, spacing: 2) {
                                ForEach(viewModel.paths, id: \.self) { path in
                                    PathRow(path: path)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .background(GitHubTheme.bgInset)
                        .cornerRadius(GitHubTheme.cornerRadius)
                        .overlay(
                            RoundedRectangle(cornerRadius: GitHubTheme.cornerRadius)
                                .stroke(GitHubTheme.borderDefault, lineWidth: GitHubTheme.borderWidth)
                        )
                    }
                }
                .frame(minWidth: 300)
            }
            
            GHCard {
                HStack {
                    Button("生成 JSONPath 路径图") {
                        viewModel.generatePaths()
                    }
                    .buttonStyle(GHButtonStyle(isPrimary: true))
                    
                    Button("重置") {
                        viewModel.paths = []
                        viewModel.errorMessage = nil
                    }
                    .buttonStyle(GHButtonStyle())
                    
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(GitHubTheme.fgDanger)
                            .font(.caption)
                            .padding(.leading)
                    }
                    
                    Spacer()
                }
            }
        }
    }
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("路径拓扑分析")
                .font(.title2.bold())
                .foregroundColor(.white)
            Text("自动解构 JSON 层次结构并映射完整的 JSONPath 路由")
                .font(.caption)
                .foregroundColor(GitHubTheme.fgMuted)
        }
    }
    
    private func copyAllPaths() {
        let allPaths = viewModel.paths.joined(separator: "\n")
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(allPaths, forType: .string)
    }
}

struct PathRow: View {
    let path: String
    
    var body: some View {
        HStack {
            Text(path)
                .font(.system(.caption, design: .monospaced))
                .foregroundColor(GitHubTheme.fgAccent)
                .textSelection(.enabled)
            Spacer()
            Button(action: {
                let pasteboard = NSPasteboard.general
                pasteboard.clearContents()
                pasteboard.setString(path, forType: .string)
            }) {
                Image(systemName: "doc.on.doc")
                    .font(.caption2)
                    .foregroundColor(GitHubTheme.fgMuted)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.white.opacity(0.02))
    }
}

#Preview {
    PathGeneratorView()
}
