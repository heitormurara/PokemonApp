import XCTest
@testable import onTopPoke

final class SpeciesListPresenterTests: XCTestCase {
    override func setUp() {}
    
    override func tearDown() {}
    
    func test_getSpecies_whenLoading_doesntRequestFromService() {
        let pokemonServiceMock = PokemonServiceMock()
        let loadManager = LoadManager(isLoading: true)
        let sut = SpeciesListPresenter(pokeAPIService: PokeAPIServiceDummy(),
                                       pokemonService: pokemonServiceMock,
                                       loadManager: loadManager,
                                       dispatcher: DispatcherStub())
        sut.getSpecies()
        
        XCTAssertFalse(pokemonServiceMock.gotSpecies, "getSpecies should NOT request from Service when it's loading.")
    }
    
    func test_getSpecies_whenNotLoading_whenNextPage_requestsFromService() {
        let pokemonServiceMock = PokemonServiceMock()
        let sut = SpeciesListPresenter(pokeAPIService: PokeAPIServiceDummy(),
                                       pokemonService: pokemonServiceMock,
                                       dispatcher: DispatcherStub())
        sut.getSpecies()
        
        XCTAssertTrue(pokemonServiceMock.gotSpecies, "getSpecies should request from Service when it's NOT loading.")
    }
    
    func test_getSpecies_whenNotLoading_whenNextPage_setsLoading() {
        let pokemonServiceStub = PokemonServiceStub()
        let loadManagerMock = LoadManagerMock(isLoading: false)
        let sut = SpeciesListPresenter(pokeAPIService: PokeAPIServiceDummy(),
                                       pokemonService: pokemonServiceStub,
                                       loadManager: loadManagerMock,
                                       dispatcher: DispatcherStub())
        sut.getSpecies()
        
        XCTAssertTrue(loadManagerMock.didSetIsLoading, "getSpecies should set LoadManaging.isLoading when not loading and next page exists.")
        XCTAssertTrue(loadManagerMock.isLoading, "getSpecies should set LoadManaging.isLoading to true when not loading and next page exists.")
    }
    
    func test_getSpecies_whenNotLoading_whenNextPage_displaysFooterSpinner() {
        let sut = SpeciesListPresenter(pokeAPIService: PokeAPIServiceDummy(),
                                       pokemonService: PokemonServiceDummy(),
                                       dispatcher: DispatcherStub())
        let viewControllerMock = SpeciesListViewControllerMock()
        sut.viewControllerDelegate = viewControllerMock
        sut.getSpecies()
        
        XCTAssertTrue(viewControllerMock.setFooterSpinnerVisibility, "getImages should set footer spinner visibility.")
        XCTAssertTrue(viewControllerMock.isFooterSpinnerViewVisible, "getImages should set footer spinner visible.")
    }
    
    func test_getSpecies_whenNilNextPage_doesntRequestFromService() {
        let pokemonServiceMock = PokemonServiceMock()
        let paginationManager = PaginationManager(nextPage: nil)
        let sut = SpeciesListPresenter(pokeAPIService: PokeAPIServiceDummy(),
                                       pokemonService: pokemonServiceMock,
                                       paginationManager: paginationManager,
                                       dispatcher: DispatcherStub())
        sut.getSpecies()
        
        XCTAssertFalse(pokemonServiceMock.gotSpecies, "getSpecies should NOT request from Service when next page inexists.")
    }
    
    func test_getSpecies_onServiceSuccess_updatesNextPage() {
        let pokemonServiceStub = PokemonServiceStub()
        let paginationManagerMock = PaginationManagerMock(nextPage: Page(limit: 20, offset: 0))
        let sut = SpeciesListPresenter(pokeAPIService: PokeAPIServiceDummy(),
                                       pokemonService: pokemonServiceStub,
                                       paginationManager: paginationManagerMock,
                                       dispatcher: DispatcherStub())
        sut.getSpecies()
        
        XCTAssertTrue(paginationManagerMock.didSetNextPage, "getSpecies should set PaginationManaging.nextPage on service success.")
    }
    
    func test_getSpecies_onServiceSuccess_requestsImages() {
        let pokeAPIServiceMock = PokeAPIServiceMock()
        let sut = SpeciesListPresenter(pokeAPIService: pokeAPIServiceMock,
                                       pokemonService: PokemonServiceStub(),
                                       dispatcher: DispatcherStub())
        sut.getSpecies()
        
        XCTAssertTrue(pokeAPIServiceMock.gotImages, "getSpecies should request images when PokemonService completes successfully.")
    }
    
    func test_getImages_onDefer_disablesLoading() {
        let loadManagerMock = LoadManagerMock(isLoading: false)
        let sut = SpeciesListPresenter(pokeAPIService: PokeAPIServiceStub(),
                                       pokemonService: PokemonServiceStub(),
                                       loadManager: loadManagerMock,
                                       dispatcher: DispatcherStub())
        sut.getSpecies()
        
        XCTAssertTrue(loadManagerMock.didSetIsLoading, "getImages should set LoadManaging.isLoading when deferred.")
        XCTAssertFalse(loadManagerMock.isLoading, "getImages should set LoadManaging.isLoading to false when deferred.")
    }
    
    func test_getImages_onResult_appendsSpecies() {
        let sut = SpeciesListPresenter(pokeAPIService: PokeAPIServiceStub(),
                                       pokemonService: PokemonServiceStub(),
                                       dispatcher: DispatcherStub())
        let speciesBeforeCall = sut.species
        sut.getSpecies()
        let speciesAfterCall = sut.species
        
        XCTAssertNotEqual(speciesBeforeCall.count, speciesAfterCall.count, "getImages should update Presenter's species when receives new species on completion.")
    }
    
    func test_getImages_onResult_hidesFooterSpinner() {
        let sut = SpeciesListPresenter(pokeAPIService: PokeAPIServiceStub(),
                                       pokemonService: PokemonServiceStub(),
                                       dispatcher: DispatcherStub())
        let viewControllerMock = SpeciesListViewControllerMock()
        sut.viewControllerDelegate = viewControllerMock
        sut.getSpecies()
        
        XCTAssertTrue(viewControllerMock.setFooterSpinnerVisibility, "getImages should set footer spinner visibility on completion.")
        XCTAssertFalse(viewControllerMock.isFooterSpinnerViewVisible, "getImages should set footer spinner hidden on completion.")
    }
    
    func test_getImages_onResult_reloadsData() {
        let sut = SpeciesListPresenter(pokeAPIService: PokeAPIServiceStub(),
                                       pokemonService: PokemonServiceStub(),
                                       dispatcher: DispatcherStub())
        let viewControllerMock = SpeciesListViewControllerMock()
        sut.viewControllerDelegate = viewControllerMock
        sut.getSpecies()
        
        XCTAssertTrue(viewControllerMock.reloadedData, "getImages should reload ViewController data on completion.")
    }
}
