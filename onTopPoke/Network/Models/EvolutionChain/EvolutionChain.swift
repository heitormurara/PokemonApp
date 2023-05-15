struct EvolutionChain: Decodable {
    let originSpecie: Specie
    let chain: [EvolutionChain]
    
    var nextChainItem: EvolutionChain? {
        chain.first
    }
    
    enum CodingKeys: String, CodingKey {
        case originSpecie = "species"
        case chain = "evolves_to"
    }
}
