protocol LoadManaging {
    var isLoading: Bool { get set }
}

struct LoadManager: LoadManaging {
    var isLoading: Bool
}
