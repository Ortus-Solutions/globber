component extends="coldbox.system.testing.BaseTestCase" {

    /**
    * @beforeAll
    */
    function registerModuleUnderTest() {
        getController().getModuleService()
            .registerAndActivateModule( "globber", "testingModuleRoot" );
    }

    /**
    * @beforeEach
    */
    function setupIntegrationTest() {
        setup();
    }

}