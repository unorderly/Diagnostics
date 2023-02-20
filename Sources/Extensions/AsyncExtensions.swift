extension Sequence {
    func map<T>(
        _ transform: (Element) async throws -> T
    ) async rethrows -> [T] {
        var values = [T]()

        for element in self {
            try await values.append(transform(element))
        }

        return values
    }
    
    public func flatMap<SegmentOfResult>(
        _ transform: (Self.Element) async throws -> SegmentOfResult
    ) async rethrows -> [SegmentOfResult.Element] where SegmentOfResult : Sequence {
        var values = [SegmentOfResult.Element]()
        for element in self {
            try await values.append(contentsOf: transform(element))
        }

        return values
    }
    
}
