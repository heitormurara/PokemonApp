import XCTest
@testable import onTopPoke

final class SpeciesListPresenterTests: XCTestCase {
    override func setUp() {}
    
    override func tearDown() {}
    
    // MARK: - getSpecies
    
    func test_getSpecies_whenLoading_doesntRequestFromService() {
        let pokemonServiceMock = PokemonServiceMock()
        let sut = SpeciesListPresenter(pokeAPIService: PokeAPIServiceDummy(),
                                       pokemonService: pokemonServiceMock,
                                       dispatcher: DispatcherStub())
        sut.startLoading()
        sut.getSpecies()
        
        XCTAssertFalse(pokemonServiceMock.gotSpecies, "getSpecies should NOT request from Service when it's loading.")
    }
    
    func test_getSpecies_whenNotLoading_requestsFromService() {
        let pokemonServiceMock = PokemonServiceMock()
        let sut = SpeciesListPresenter(pokeAPIService: PokeAPIServiceDummy(),
                                       pokemonService: pokemonServiceMock,
                                       dispatcher: DispatcherStub())
        sut.getSpecies()
        
        XCTAssertTrue(pokemonServiceMock.gotSpecies, "getSpecies should request from Service when it's NOT loading.")
    }
    
    // MARK: When not loading and it's the first load
    
    func test_getSpecies_whenNotLoading_whenFirstLoad_setsLoading() {
        let pokemonServiceStub = PokemonServiceStub()
        let sut = SpeciesListPresenter(pokeAPIService: PokeAPIServiceDummy(),
                                       pokemonService: pokemonServiceStub,
                                       dispatcher: DispatcherStub())
        sut.getSpecies()
        
        XCTAssertTrue(sut.isLoading, "getSpecies should set isLoading to true when not loading and it's the first load.")
    }
    
    func test_getSpecies_whenNotLoading_whenFirstLoad_displaysLoading() {
        let sut = SpeciesListPresenter(pokeAPIService: PokeAPIServiceDummy(),
                                       pokemonService: PokemonServiceDummy(),
                                       dispatcher: DispatcherStub())
        let viewControllerMock = SpeciesListViewControllerMock()
        sut.viewControllerDelegate = viewControllerMock
        sut.getSpecies()

        XCTAssertTrue(viewControllerMock.didSetLoadingVisibility, "getImages should set footer spinner visibility when not loading and will load the next page.")
        XCTAssertTrue(viewControllerMock.isLoadingVisible, "getImages should set footer spinner visible when not load and will load the next page.")
    }
    
    // MARK: When not loading and it's the next load
    
    func test_getSpecies_whenNotLoading_whenNextLoad_setsLoading() {
        let pokemonServiceStub = PokemonServiceStub()
        let sut = SpeciesListPresenter(pokeAPIService: PokeAPIServiceDummy(),
                                       pokemonService: pokemonServiceStub,
                                       dispatcher: DispatcherStub())
        sut.getSpecies()
        
        XCTAssertTrue(sut.isLoading, "getSpecies should set isLoading to true when not loading and will load next page.")
    }
    
    func test_getSpecies_whenNotLoading_whenNextLoad_displaysFooterSpinner() {
        let sut = SpeciesListPresenter(pokeAPIService: PokeAPIServiceStub(),
                                       pokemonService: PokemonServiceStub(),
                                       dispatcher: DispatcherStub())
        let viewControllerMock = SpeciesListViewControllerMock()
        sut.viewControllerDelegate = viewControllerMock
        sut.getSpecies()
        sut.getSpecies()

        XCTAssertTrue(viewControllerMock.didSetFooterSpinnerVisibility, "getImages should set footer spinner visibility when not loading and will load the next page.")
        XCTAssertTrue(viewControllerMock.didSetFooterSpinnerVisible, "getImages should set footer spinner visible when not load and will load the next page.")
    }
    
    // MARK: When nextPage is nil
    
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
    
    // MARK: On service successs
    
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
    
    // MARK: On service failure
    
    func test_getSpecies_onServiceFailure_setsLoading() {
        
    }
    
    func test_getSpecies_onServiceFailure_whenFirstLoad_hidesLoading() {
        
    }
    
    func test_getSpecies_onServiceFailure_whenNextLoad_hidesFooterSpinner() {
        
    }
    
    func test_getSpecies_onServiceFailure_displaysError() {
        
    }
    
    // MARK: - getImages
    
    // MARK: On defer
    
    func test_getImages_onDefer_disablesLoading() {
        let sut = SpeciesListPresenter(pokeAPIService: PokeAPIServiceStub(),
                                       pokemonService: PokemonServiceStub(),
                                       dispatcher: DispatcherStub())
        sut.getSpecies()
        
        XCTAssertFalse(sut.isLoading, "getImages should set isLoading to false when deferred.")
    }
    
    // MARK: On service completion
    
    func test_getImages_onServiceCompletion_appendsSpecies() {
        let sut = SpeciesListPresenter(pokeAPIService: PokeAPIServiceStub(),
                                       pokemonService: PokemonServiceStub(),
                                       dispatcher: DispatcherStub())
        let speciesBeforeCall = sut.species
        sut.getSpecies()
        let speciesAfterCall = sut.species
        
        XCTAssertNotEqual(speciesBeforeCall.count, speciesAfterCall.count, "getImages should update Presenter's species when receives new species on completion.")
    }
    
    func test_getImages_onServiceCompletion_hidesFooterSpinner() {
        let sut = SpeciesListPresenter(pokeAPIService: PokeAPIServiceStub(),
                                       pokemonService: PokemonServiceStub(),
                                       dispatcher: DispatcherStub())
        let viewControllerMock = SpeciesListViewControllerMock()
        sut.viewControllerDelegate = viewControllerMock
        sut.getSpecies()
        
        XCTAssertTrue(viewControllerMock.didSetFooterSpinnerVisibility, "getImages should set footer spinner visibility on completion.")
        XCTAssertFalse(viewControllerMock.isFooterSpinnerVisible, "getImages should set footer spinner hidden on completion.")
    }
    
    func test_getImages_onServiceCompletion_reloadsData() {
        let sut = SpeciesListPresenter(pokeAPIService: PokeAPIServiceStub(),
                                       pokemonService: PokemonServiceStub(),
                                       dispatcher: DispatcherStub())
        let viewControllerMock = SpeciesListViewControllerMock()
        sut.viewControllerDelegate = viewControllerMock
        sut.getSpecies()
        
        XCTAssertTrue(viewControllerMock.reloadedData, "getImages should reload ViewController data on completion.")
    }
    
    // MARK: - displayDetails
    
    func test_displayDetails_coordinates() {
        
    }
}
