import SwiftUI

struct PerformanceView: View {
    @StateObject private var viewModel = PerformanceViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: GitHubTheme.padding) {
            headerView
            
            HStack(spacing: GitHubTheme.padding) {
                StatCard(title: "测试数据", value: "1,000 条", subtitle: "JSON 对象条目", icon: "doc.text")
                StatCard(title: "测试状态", value: viewModel.isRunning ? "进行中" : "就绪", subtitle: "Sextant 引擎", icon: "bolt.circle", color: viewModel.isRunning ? GitHubTheme.fgAccent : GitHubTheme.fgSuccess)
            }
            
            GHCard {
                VStack(alignment: .leading, spacing: GitHubTheme.smallPadding) {
                    HStack {
                        Label("控制台输出", systemImage: "terminal")
                            .font(.subheadline.bold())
                            .foregroundColor(GitHubTheme.fgMuted)
                        Spacer()
                        if !viewModel.isRunning {
                            Button("启动基准测试") {
                                Task { await viewModel.runBenchmarks() }
                            }
                            .buttonStyle(GHButtonStyle(isPrimary: true))
                        } else {
                            ProgressView()
                                .scaleEffect(0.6)
                        }
                    }
                    
                    ScrollView {
                        Text(viewModel.performanceResult)
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
                }
            }
        }
    }
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("性能基准中心")
                .font(.title2.bold())
                .foregroundColor(.white)
            Text("评估大规模 JSON 数据下的解析和查询稳定性")
                .font(.caption)
                .foregroundColor(GitHubTheme.fgMuted)
        }
        .padding(.bottom, 8)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    var color: Color = GitHubTheme.fgMuted
    
    var body: some View {
        GHCard {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: icon)
                        .foregroundColor(color)
                    Text(title)
                        .font(.caption)
                        .foregroundColor(GitHubTheme.fgMuted)
                }
                
                Text(value)
                    .font(.title2.bold())
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.caption2)
                    .foregroundColor(GitHubTheme.fgMuted)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    PerformanceView()
}
