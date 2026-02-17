import SwiftUI

struct PlaygroundView: View {
    @StateObject private var viewModel = PlaygroundViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: GitHubTheme.padding) {
            headerView
            
            HSplitView {
                GHCard {
                    VStack(alignment: .leading) {
                        Label("JSON 输入", systemImage: "curlybraces")
                            .font(.subheadline.bold())
                            .foregroundColor(GitHubTheme.fgMuted)
                        
                        TextEditor(text: $viewModel.jsonString)
                            .ghCodeStyle()
                            .frame(minHeight: 200)
                    }
                }
                .frame(minWidth: 300)
                
                GHCard {
                    VStack(alignment: .leading) {
                        Label("查询结果", systemImage: "text.justify.left")
                            .font(.subheadline.bold())
                            .foregroundColor(GitHubTheme.fgMuted)
                        
                        ScrollView {
                            Text(viewModel.result)
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(GitHubTheme.fgSuccess)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(GitHubTheme.smallPadding)
                        }
                        .background(GitHubTheme.bgInset)
                        .cornerRadius(GitHubTheme.cornerRadius)
                        .overlay(
                            RoundedRectangle(cornerRadius: GitHubTheme.cornerRadius)
                                .stroke(GitHubTheme.borderDefault, lineWidth: GitHubTheme.borderWidth)
                        )
                        .frame(minHeight: 200)
                    }
                }
                .frame(minWidth: 300)
            }
            
            GHCard {
                VStack(alignment: .leading, spacing: GitHubTheme.smallPadding) {
                    Label("JSONPath 命令", systemImage: "command")
                        .font(.subheadline.bold())
                        .foregroundColor(GitHubTheme.fgMuted)
                    
                    HStack {
                        TextField("输入 JSONPath...", text: $viewModel.query)
                            .textFieldStyle(.plain)
                            .padding(8)
                            .background(GitHubTheme.bgInset)
                            .cornerRadius(GitHubTheme.cornerRadius)
                            .overlay(
                                RoundedRectangle(cornerRadius: GitHubTheme.cornerRadius)
                                    .stroke(GitHubTheme.borderDefault, lineWidth: GitHubTheme.borderWidth)
                            )
                        
                        Button("运行查询") {
                            viewModel.runQuery()
                        }
                        .buttonStyle(GHButtonStyle(isPrimary: true))
                    }
                    
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(GitHubTheme.fgDanger)
                            .font(.caption)
                    }
                    
                    quickQueries
                }
            }
        }
        .onAppear {
            viewModel.runQuery()
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("终端调试器")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                Text("运行 JSONPath 表达式并实时获取输出结果")
                    .font(.caption)
                    .foregroundColor(GitHubTheme.fgMuted)
            }
            Spacer()
            
            HStack(spacing: 8) {
                Circle().fill(GitHubTheme.fgSuccess).frame(width: 8, height: 8)
                Text("Sextant 引擎就绪")
                    .font(.caption)
                    .foregroundColor(GitHubTheme.fgMuted)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(GitHubTheme.bgSubtle)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(GitHubTheme.borderDefault, lineWidth: 1)
            )
        }
    }
    
    private var quickQueries: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                QuickQueryButton(title: "所有作者", query: "$..book[*].author", viewModel: viewModel)
                QuickQueryButton(title: "特价书", query: "$.store.book[?(@.display-price < 10)]", viewModel: viewModel)
                QuickQueryButton(title: "ISBN 列表", query: "$..book[?(@.isbn)]", viewModel: viewModel)
                QuickQueryButton(title: "所有价格", query: "$..display-price", viewModel: viewModel)
            }
            .padding(.top, 4)
        }
    }
}

struct QuickQueryButton: View {
    let title: String
    let query: String
    @ObservedObject var viewModel: PlaygroundViewModel
    
    var body: some View {
        Button(title) {
            viewModel.query = query
            viewModel.runQuery()
        }
        .buttonStyle(GHButtonStyle())
        .font(.caption)
    }
}

#Preview {
    PlaygroundView()
}
