import Foundation

protocol DispatchingGroup {
    func enter()
    func leave()
    func notify(on queue: DispatchQueue,
                execute work: @escaping () -> Void)
}
