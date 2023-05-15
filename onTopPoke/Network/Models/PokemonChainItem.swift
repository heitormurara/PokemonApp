struct PokemonChainItem: Decodable {
    let originSpecie: PokemonSpecieItem
    let chain: [PokemonChainItem]
    
    var nextChainItem: PokemonChainItem? {
        chain.first
    }
    
    enum CodingKeys: String, CodingKey {
        case originSpecie = "species"
        case chain = "evolves_to"
    }
}
