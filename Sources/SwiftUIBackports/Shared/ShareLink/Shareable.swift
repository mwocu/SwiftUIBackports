import SwiftUI

@available(iOS, deprecated: 16.0)
@available(macOS, deprecated: 13.0)
@available(watchOS, deprecated: 9.0)
public protocol BackportTransferable {
    var pathExtension: String { get }
    var itemProvider: NSItemProvider? { get }
}

internal struct ActivityItem<Data> where Data: RandomAccessCollection, Data.Element: BackportTransferable {
    internal var data: Data
}

extension String: BackportTransferable {
    public var pathExtension: String { "txt" }
    public var itemProvider: NSItemProvider? {
        do {
            let url = URL(fileURLWithPath: NSTemporaryDirectory())
                .appendingPathComponent("\(UUID().uuidString)")
                .appendingPathExtension(pathExtension)
            try write(to: url, atomically: true, encoding: .utf8)
            return .init(contentsOf: url)
        } catch {
            return nil
        }
    }
}

extension URL: BackportTransferable {
    public var itemProvider: NSItemProvider? {
        .init(contentsOf: self)
    }
}

extension Image: BackportTransferable {
    public var pathExtension: String { "jpg" }
    public var itemProvider: NSItemProvider? {
        do {
            let url = URL(fileURLWithPath: NSTemporaryDirectory())
                .appendingPathComponent("\(UUID().uuidString)")
                .appendingPathExtension(pathExtension)
            let renderer = ImageRenderer(content: self)
            let data = renderer.uiImage?.jpegData(compressionQuality: 0.8)
            try data?.write(to: url, options: .atomic)
            return .init(contentsOf: url)
        } catch {
            return nil
        }
    }
}

extension PlatformImage: BackportTransferable {
    public var pathExtension: String { "jpg" }
    public var itemProvider: NSItemProvider? {
        do {
            let url = URL(fileURLWithPath: NSTemporaryDirectory())
                .appendingPathComponent("\(UUID().uuidString)")
                .appendingPathExtension(pathExtension)
            let data = jpegData(compressionQuality: 0.8)
            try data?.write(to: url, options: .atomic)
            return .init(contentsOf: url)
        } catch {
            return nil
        }
    }
}
