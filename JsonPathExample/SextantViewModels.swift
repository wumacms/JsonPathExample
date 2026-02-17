import SwiftUI
import Combine

/// Playground 视图的模型
class PlaygroundViewModel: ObservableObject {
    @Published var jsonString: String = SampleJSON.bookstore
    @Published var query: String = "$..book[?(@.display-price < 10)]"
    @Published var result: String = ""
    @Published var errorMessage: String?
    
    private let sextantService: SextantServiceProtocol
    
    init(sextantService: SextantServiceProtocol = SextantService.shared) {
        self.sextantService = sextantService
    }
    
    func runQuery() {
        errorMessage = nil
        result = ""
        
        switch sextantService.queryAndFormat(json: jsonString, path: query) {
        case .success(let formattedString):
            result = formattedString
        case .failure(let error):
            errorMessage = error.localizedDescription
        }
    }
}

/// 性能测试视图的模型
class PerformanceViewModel: ObservableObject {
    @Published var performanceResult: String = ""
    @Published var isRunning: Bool = false
    
    private let performanceService: PerformanceServiceProtocol
    
    init(performanceService: PerformanceServiceProtocol = PerformanceService.shared) {
        self.performanceService = performanceService
    }
    
    private static let largeJson: String = {
        var str = "["
        for i in 0..<1000 {
            str += "{\"id\": \(i), \"name\": \"Item \(i)\", \"value\": \(Double(i) * 1.5), \"active\": \(i % 2 == 0)},"
        }
        str.removeLast()
        str += "]"
        return str
    }()
    
    @MainActor
    func runBenchmarks() async {
        isRunning = true
        performanceResult = "正在运行基准测试..."
        
        let result = await performanceService.runBenchmark(json: Self.largeJson)
        
        performanceResult = result
        isRunning = false
    }
}

/// 路径生成视图的模型
class PathViewModel: ObservableObject {
    @Published var jsonString: String = SampleJSON.people
    @Published var paths: [String] = []
    @Published var errorMessage: String?
    
    private let pathService: PathServiceProtocol
    
    init(pathService: PathServiceProtocol = PathService.shared) {
        self.pathService = pathService
    }
    
    func generatePaths() {
        errorMessage = nil
        
        switch pathService.generatePaths(from: jsonString) {
        case .success(let generatedPaths):
            paths = generatedPaths
        case .failure(let error):
            errorMessage = error.localizedDescription
            paths = []
        }
    }
}
