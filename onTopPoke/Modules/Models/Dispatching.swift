protocol Dispatching {
    func async(_ work: @escaping () -> Void)
}
