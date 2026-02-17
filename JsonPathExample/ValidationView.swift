import SwiftUI

struct ValidationView: View {
    @State private var query: String = ""
    @State private var validationResult: String = "等待输入查询语句"
    @State private var isValid: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: GitHubTheme.padding) {
            headerView
            
            GHCard {
                VStack(alignment: .leading, spacing: GitHubTheme.smallPadding) {
                    Label("语法验证器", systemImage: "signature")
                        .font(.subheadline.bold())
                        .foregroundColor(GitHubTheme.fgMuted)
                    
                    TextField("输入 JSONPath 语句进行实时校验...", text: $query)
                        .textFieldStyle(.plain)
                        .padding(GitHubTheme.padding)
                        .background(GitHubTheme.bgInset)
                        .cornerRadius(GitHubTheme.cornerRadius)
                        .overlay(
                            RoundedRectangle(cornerRadius: GitHubTheme.cornerRadius)
                                .stroke(GitHubTheme.borderDefault, lineWidth: GitHubTheme.borderWidth)
                        )
                        .font(.system(.body, design: .monospaced))
                        .onChange(of: query) { _, newValue in
                            validate(query: newValue)
                        }
                    
                    HStack(spacing: 12) {
                        Image(systemName: query.isEmpty ? "ellipsis.circle" : (isValid ? "checkmark.circle.fill" : "xmark.circle.fill"))
                            .foregroundColor(query.isEmpty ? GitHubTheme.fgMuted : (isValid ? GitHubTheme.fgSuccess : GitHubTheme.fgDanger))
                            .font(.title2)
                        
                        VStack(alignment: .leading) {
                            Text(isValid ? "有效语法" : (query.isEmpty ? "等待输入" : "语法错误"))
                                .font(.headline)
                                .foregroundColor(query.isEmpty ? GitHubTheme.fgMuted : (isValid ? GitHubTheme.fgSuccess : GitHubTheme.fgDanger))
                            
                            Text(validationResult)
                                .font(.caption)
                                .foregroundColor(GitHubTheme.fgMuted)
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .background(GitHubTheme.bgSubtle)
                    .cornerRadius(GitHubTheme.cornerRadius)
                    .overlay(
                        RoundedRectangle(cornerRadius: GitHubTheme.cornerRadius)
                            .stroke(query.isEmpty ? GitHubTheme.borderDefault : (isValid ? GitHubTheme.fgSuccess.opacity(0.3) : GitHubTheme.fgDanger.opacity(0.3)), lineWidth: 1)
                    )
                }
            }
            
            Spacer()
        }
    }
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("语法合规性检查")
                .font(.title2.bold())
                .foregroundColor(.white)
            Text("实时解析并验证 JSONPath 的结构完整性")
                .font(.caption)
                .foregroundColor(GitHubTheme.fgMuted)
        }
    }
    
    private func validate(query: String) {
        if query.isEmpty {
            validationResult = "等待输入查询语句"
            isValid = false
            return
        }
        
        if let error = SextantService.shared.validate(query: query) {
            validationResult = "\(error)"
            isValid = false
        } else {
            validationResult = "查询语句符合 JSONPath 标准。"
            isValid = true
        }
    }
}

#Preview {
    ValidationView()
}
