import Foundation
import Sextant

/// 核心 JSONPath 查询服务协议
protocol SextantServiceProtocol {
    func query(json: String, path: String) throws -> [Any]
    func validate(query: String, on json: String) -> String?
    func queryAndFormat(json: String, path: String) -> Result<String, SextantError>
}

/// 性能测试服务协议
protocol PerformanceServiceProtocol {
    func runBenchmark(json: String) async -> String
}

/// 路径生成服务协议
protocol PathServiceProtocol {
    func generatePaths(from json: String) -> Result<[String], SextantError>
}

/// Sextant 操作相关的错误类型
enum SextantError: LocalizedError {
    case invalidQuery(String)
    case noResults(String)
    case invalidJSON(String)
    case executionError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidQuery(let message):
            return "无效查询: \(message)"
        case .noResults(let message):
            return message
        case .invalidJSON(let message):
            return message
        case .executionError(let message):
            return "执行错误: \(message)"
        }
    }
}

/// 核心查询服务实现
class SextantService: SextantServiceProtocol {
    static let shared = SextantService()
    private init() {}
    
    func query(json: String, path: String) throws -> [Any] {
        guard let results = json.query(values: path) else {
            throw SextantError.executionError("查询执行失败")
        }
        return results as [Any]
    }
    
    func validate(query: String, on json: String = "{}") -> String? {
        return json.query(validate: query)
    }
    
    func queryAndFormat(json: String, path: String) -> Result<String, SextantError> {
        if let error = validate(query: path) {
            return .failure(.invalidQuery(error))
        }
        
        do {
            let results = try query(json: json, path: path)
            
            if results.isEmpty {
                return .success("[]")
            }
            
            let displayObject: Any
            if results.count == 1, let firstElement = results.first {
                if firstElement is [Any] || firstElement is [String: Any] {
                    displayObject = firstElement
                } else {
                    displayObject = results
                }
            } else {
                displayObject = results
            }
            
            if let data = try? JSONSerialization.data(withJSONObject: displayObject, options: .prettyPrinted),
               let string = String(data: data, encoding: .utf8) {
                return .success(string)
            } else {
                return .success("\(displayObject)")
            }
        } catch {
            return .failure(.noResults("未找到结果或查询执行错误"))
        }
    }
}

/// 性能测试服务实现
class PerformanceService: PerformanceServiceProtocol {
    static let shared = PerformanceService()
    private init() {}
    
    func runBenchmark(json: String) async -> String {
        return await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                var output = ""
                
                // Warmup
                _ = json.query(values: "$[0].id")
                
                let testCases = [
                    ("$[500].name", 100, "简单查询"),
                    ("$[?(@.active == true)]", 10, "过滤查询"),
                    ("$..name", 10, "深度扫描")
                ]
                
                for (path, iterations, label) in testCases {
                    let start = Date()
                    for _ in 0..<iterations {
                        _ = json.query(values: path)
                    }
                    let end = Date()
                    let time = end.timeIntervalSince(start)
                    output += "\(iterations) 次\(label) (\(path)): \(String(format: "%.4f", time))s\n"
                }
                
                continuation.resume(returning: output)
            }
        }
    }
}

/// 路径生成服务实现
class PathService: PathServiceProtocol {
    static let shared = PathService()
    private init() {}
    
    func generatePaths(from json: String) -> Result<[String], SextantError> {
        guard let data = json.data(using: .utf8) else {
            return .failure(.invalidJSON("无法解析 JSON 字符串"))
        }
        
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            var paths = Set<String>()
            extractPaths(from: jsonObject, currentPath: "$", paths: &paths)
            return .success(Array(paths).sorted())
        } catch {
            return .failure(.invalidJSON("JSON 解析错误: \(error.localizedDescription)"))
        }
    }
    
    private func extractPaths(from value: Any, currentPath: String, paths: inout Set<String>) {
        if currentPath != "$" {
            paths.insert(currentPath)
        }
        
        if let dict = value as? [String: Any] {
            for (key, val) in dict {
                let newPath = formatPath(currentPath: currentPath, key: key)
                extractPaths(from: val, currentPath: newPath, paths: &paths)
            }
        } else if let array = value as? [Any] {
            var allKeys = Set<String>()
            for item in array {
                if let dict = item as? [String: Any] {
                    allKeys.formUnion(dict.keys)
                }
            }
            
            for key in allKeys.sorted() {
                let newPath = formatPath(currentPath: "\(currentPath)[*]", key: key)
                paths.insert(newPath)
                
                for item in array {
                    if let dict = item as? [String: Any],
                       let val = dict[key] {
                        if val is [String: Any] || val is [Any] {
                            extractPaths(from: val, currentPath: newPath, paths: &paths)
                        }
                    }
                }
            }
        }
    }
    
    private func formatPath(currentPath: String, key: String) -> String {
        let needsBracketNotation = key.contains { ":.- ".contains($0) }
        return needsBracketNotation ? "\(currentPath)['\(key)']" : "\(currentPath).\(key)"
    }
}
