import XCTest
@testable import onTopPoke

final class SpeciesListPresenterTests: XCTestCase {
    override func setUp() {}
    
    override func tearDown() {}
    
    func test_getSpecies_whenLoading_doesntRequestFromService() {
        let pokemonServiceMock = PokemonServiceMock()
        let paginationManager = PaginationManager(nextPage: Page(limit: 20, offset: 0), isLoading: true)
        let sut = SpeciesListPresenter(viewControllerDelegate: SpeciesListViewControllerDummy(),
                                       pokeAPIService: PokeAPIDummy(),
                                       pokemonService: pokemonServiceMock,
                                       paginationManager: paginationManager)
        sut.getSpecies()
        
        XCTAssertFalse(pokemonServiceMock.gotSpecies, "getSpecies should NOT request from Service when it's loading.")
    }
    
    func test_getSpecies_whenNotLoading_whenNextPage_requestsFromService() {
        let pokemonServiceMock = PokemonServiceMock()
        let paginationManager = PaginationManager(nextPage: Page(limit: 20, offset: 0), isLoading: false)
        let sut = SpeciesListPresenter(viewControllerDelegate: SpeciesListViewControllerDummy(),
                                       pokeAPIService: PokeAPIDummy(),
                                       pokemonService: pokemonServiceMock,
                                       paginationManager: paginationManager)
        sut.getSpecies()
        
        XCTAssertTrue(pokemonServiceMock.gotSpecies, "getSpecies should request from Service when it's NOT loading.")
    }
    
    func test_getSpecies_whenNotLoading_whenNextPage_setsLoading() {
        let pokemonServiceStub = PokemonServiceStub()
        let paginationManagerMock = PaginationManagerMock(nextPage: Page(limit: 20, offset: 0), isLoading: false)
        let sut = SpeciesListPresenter(viewControllerDelegate: SpeciesListViewControllerDummy(),
                                       pokeAPIService: PokeAPIDummy(),
                                       pokemonService: pokemonServiceStub,
                                       paginationManager: paginationManagerMock)
        sut.getSpecies()
        
        XCTAssertTrue(paginationManagerMock.didSetIsLoading, "getSpecies should set PaginationManaging.isLoading when not loading and next page exists.")
        XCTAssertTrue(paginationManagerMock.isLoading, "getSpecies should set PaginationManaging.isLoading to true when not loading and next page exists.")
    }
    
    func test_getSpecies_whenNilNextPage_doesntRequestFromService() {
        let pokemonServiceMock = PokemonServiceMock()
        let paginationManager = PaginationManager(nextPage: nil, isLoading: false)
        let sut = SpeciesListPresenter(viewControllerDelegate: SpeciesListViewControllerDummy(),
                                       pokeAPIService: PokeAPIDummy(),
                                       pokemonService: pokemonServiceMock,
                                       paginationManager: paginationManager)
        sut.getSpecies()
        
        XCTAssertFalse(pokemonServiceMock.gotSpecies, "getSpecies should NOT request from Service when next page inexists.")
    }
    
    func test_getSpecies_onServiceSuccess_updatesNextPage() {
        let pokemonServiceStub = PokemonServiceStub()
        let paginationManagerMock = PaginationManagerMock(nextPage: Page(limit: 20, offset: 0), isLoading: false)
        let sut = SpeciesListPresenter(viewControllerDelegate: SpeciesListViewControllerDummy(),
                                       pokeAPIService: PokeAPIDummy(),
                                       pokemonService: pokemonServiceStub,
                                       paginationManager: paginationManagerMock)
        sut.getSpecies()
        
        XCTAssertTrue(paginationManagerMock.didSetNextPage, "getSpecies should set PaginationManaging.nextPage on service success.")
    }
    
    func test_getSpecies_onServiceSuccess_requestsImages() {
        
    }
}
