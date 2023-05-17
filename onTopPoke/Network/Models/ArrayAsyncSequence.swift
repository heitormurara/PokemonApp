struct ArrayAsyncSequence<Element>: AsyncSequence {
    let array: [Element]

    func makeAsyncIterator() -> AsyncIterator {
        return AsyncIterator(array: array)
    }

    struct AsyncIterator: AsyncIteratorProtocol {
        let array: [Element]
        var currentIndex = 0

        mutating func next() async -> Element? {
            guard currentIndex < array.count else {
                return nil
            }

            let element = array[currentIndex]
            currentIndex += 1
            return element
        }
    }
}
