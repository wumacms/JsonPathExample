import SwiftUI

struct ModificationView: View {
    @State private var jsonString: String = SampleJSON.people
    @State private var resultMessage: String = "点击右侧操作以查看结果"
    
    var body: some View {
        VStack(alignment: .leading, spacing: GitHubTheme.padding) {
            headerView
            
            HStack(alignment: .top, spacing: GitHubTheme.padding) {
                GHCard {
                    VStack(alignment: .leading) {
                        Label("数据集编辑器", systemImage: "pencil.and.outline")
                            .font(.subheadline.bold())
                            .foregroundColor(GitHubTheme.fgMuted)
                        
                        TextEditor(text: $jsonString)
                            .ghCodeStyle()
                            .frame(minHeight: 400)
                    }
                }
                
                VStack(spacing: GitHubTheme.padding) {
                    GHCard {
                        VStack(alignment: .leading, spacing: GitHubTheme.smallPadding) {
                            Text("快速查询")
                                .font(.subheadline.bold())
                                .foregroundColor(GitHubTheme.fgMuted)
                                .padding(.bottom, 4)
                            
                            VStack(spacing: 8) {
                                OperationButton(title: "所有男性", icon: "person.fill", action: queryMales)
                                OperationButton(title: "所有女性", icon: "person.fill", action: queryFemales)
                                OperationButton(title: "提取姓名", icon: "text.quote", action: queryAllNames)
                                OperationButton(title: "年龄 > 40", icon: "arrow.up.circle", action: queryAgeOver40)
                                
                                Divider().background(GitHubTheme.borderDefault)
                                
                                Button(action: resetJson) {
                                    HStack {
                                        Image(systemName: "arrow.counterclockwise")
                                        Text("重置数据集")
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(GHButtonStyle())
                                .foregroundColor(GitHubTheme.fgDanger)
                            }
                        }
                    }
                    .frame(width: 250)
                    
                    GHCard {
                        VStack(alignment: .leading) {
                            Text("输出")
                                .font(.subheadline.bold())
                                .foregroundColor(GitHubTheme.fgMuted)
                            
                            ScrollView {
                                Text(resultMessage)
                                    .font(.system(.caption, design: .monospaced))
                                    .foregroundColor(GitHubTheme.fgSuccess)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(8)
                            }
                            .background(GitHubTheme.bgInset)
                            .cornerRadius(GitHubTheme.cornerRadius)
                            .frame(maxHeight: .infinity)
                        }
                    }
                    .frame(width: 250)
                }
            }
        }
    }
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("数据建模与筛选")
                .font(.title2.bold())
                .foregroundColor(.white)
            Text("基于 Sextant 引擎的动态 JSON 数据子集提取")
                .font(.caption)
                .foregroundColor(GitHubTheme.fgMuted)
        }
    }
    
    private func queryMales() { execute(path: "$..people[?(@.gender=='m')]") }
    private func queryFemales() { execute(path: "$..people[?(@.gender=='f')]") }
    private func queryAllNames() { execute(path: "$..people[*].name") }
    private func queryAgeOver40() { execute(path: "$..people[?(@.age > 40)]") }
    
    private func execute(path: String) {
        switch SextantService.shared.queryAndFormat(json: jsonString, path: path) {
        case .success(let result):
            resultMessage = result
        case .failure(let error):
            resultMessage = "Error: \(error.localizedDescription)"
        }
    }

    private func resetJson() {
        jsonString = SampleJSON.people
        resultMessage = "数据集已重置"
    }
}

struct OperationButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .frame(width: 16)
                Text(title)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption2)
                    .opacity(0.5)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(GHButtonStyle())
    }
}

#Preview {
    ModificationView()
}
