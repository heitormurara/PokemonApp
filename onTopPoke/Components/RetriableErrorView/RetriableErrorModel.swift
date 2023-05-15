struct RetriableErrorModel {
    let image: ErrorImage
    let text: String
    let tryAgainAction: (() -> Void)
}
