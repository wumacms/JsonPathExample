import SwiftUI

struct SidebarView: View {
    @State private var selection: String? = "playground"
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selection) {
                Section {
                    SidebarItem(title: "演示场", icon: "terminal", tag: "playground", selection: $selection)
                    SidebarItem(title: "路径生成器", icon: "list.bullet.indent", tag: "pathgenerator", selection: $selection)
                    SidebarItem(title: "查询验证", icon: "checkmark.circle", tag: "validation", selection: $selection)
                    SidebarItem(title: "数据筛选", icon: "pencil.line", tag: "modification", selection: $selection)
                    SidebarItem(title: "性能测试", icon: "bolt.fill", tag: "performance", selection: $selection)
                } header: {
                    Text("工具箱")
                        .font(.caption)
                        .foregroundColor(GitHubTheme.fgMuted)
                }
            }
            .listStyle(.sidebar)
            .background(GitHubTheme.bgSubtle)
            .navigationTitle("Sextant Pro")
        } detail: {
            ZStack {
                GitHubTheme.bgDefault.ignoresSafeArea()
                
                Group {
                    switch selection {
                    case "playground":
                        PlaygroundView()
                    case "pathgenerator":
                        PathGeneratorView()
                    case "validation":
                        ValidationView()
                    case "modification":
                        ModificationView()
                    case "performance":
                        PerformanceView()
                    default:
                        VStack {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 48))
                                .foregroundColor(GitHubTheme.fgMuted)
                            Text("请从左侧选择一个工具")
                                .font(.headline)
                                .foregroundColor(GitHubTheme.fgMuted)
                        }
                    }
                }
                .padding()
            }
        }
    }
}

struct SidebarItem: View {
    let title: String
    let icon: String
    let tag: String
    @Binding var selection: String?
    
    var body: some View {
        Button(action: { selection = tag }) {
            HStack {
                Image(systemName: icon)
                    .frame(width: 20)
                    .foregroundColor(selection == tag ? GitHubTheme.fgAccent : GitHubTheme.fgMuted)
                Text(title)
                    .foregroundColor(selection == tag ? .white : GitHubTheme.fgDefault)
                Spacer()
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .background(selection == tag ? Color.blue.opacity(0.15) : Color.clear)
            .cornerRadius(4)
        }
        .buttonStyle(.plain)
        .tag(tag)
    }
}

#Preview {
    SidebarView()
}
