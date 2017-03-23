component extends="tests.resources.ModuleIntegrationSpec" appMapping="/app" {
	
	function setup() {
		super.setup();
		baseDir = expandPath( '/tests/resources/testFolders' ).listChangeDelims( '/', '\' );
	//	applicationStop();
	}
	
    function run() {
        describe( "The Globber fluent API", function() {
	        	
	    	beforeEach( function() {
	    		// Create a fresh globber for each test.
				globber = getInstance( 'globber' );
	    	} );
	    	
            it( "Can match a specific path", function() {
            	var results = globber
            		.setPattern( baseDir )
            		.matches();
            	
            	expect( results ).toHaveLength( 1 );
            	expect( results[ 1 ] ).toBe( baseDir );
			} );
	    	
            it( "Can match all sub paths", function() {
            	var results = globber
            		.setPattern( baseDir & '/**' )
            		.matches();
            		
            	expect( results ).toHaveLength( 23 );
			} );
	    	
            it( "Can match extensions in current dir", function() {
            	var results = globber
            		.setPattern( baseDir & '/*.txt' )
            		.matches();
            		
            	expect( results ).toHaveLength( 3 );
            	// Expand path makes slashes match local file system 
            	expect( results ).toInclude( expandPath( baseDir & '/foo.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/bar.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/baz.txt' ) );
			} );
	    	
            it( "Can match partial folders and files in current dir", function() {
            	var results = globber
            		.setPattern( baseDir & '/fo*' )
            		.matches();
            		
            	expect( results ).toHaveLength( 2 );
            	// Expand path makes slashes match local file system 
            	expect( results ).toInclude( expandPath( baseDir & '/foo.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food' ) );
            	
			} );
	    	
            it( "Can match a file in a sub dir", function() {
            	var results = globber
            		.setPattern( baseDir & '/**/luis.txt' )
            		.matches();
            		
            	expect( results ).toHaveLength( 1 );
            	// Expand path makes slashes match local file system 
            	expect( results[ 1 ] ).toBe( expandPath( baseDir & '/names/luis.txt' ) );
            	
			} );
			
            it( "Can match all files in a deep dir", function() {
            	var results = globber
            		.setPattern( baseDir & '/food/*' )
            		.matches();
            			
            	expect( results ).toHaveLength( 5 );
            	// Expand path makes slashes match local file system 
            	expect( results ).toInclude( expandPath( baseDir & '/food/cake.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/coffee.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/pizza.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/healthy' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/unhealthy' ) );
            	
			} );
			
            it( "Can match all files recursivley in a deep dir", function() {
            	var results = globber
            		.setPattern( baseDir & '/food/**' )
            		.matches();
            	
            	expect( results ).toHaveLength( 11 );
            	// Expand path makes slashes match local file system 
            	expect( results ).toInclude( expandPath( baseDir & '/food/cake.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/coffee.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/pizza.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/healthy' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/healthy/fruits.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/healthy/milk.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/healthy/veggies.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/unhealthy' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/unhealthy/arsenic.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/unhealthy/lard.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/unhealthy/candy.txt' ) );
            	
			} );
			
            it( "Can match all files recursivley in a deep dir", function() {
            	var results = globber
            		.setPattern( baseDir & '/f?o.tx?' )
            		.matches();
            	
            	expect( results ).toHaveLength( 1 );
            	// Expand path makes slashes match local file system 
            	expect( results[ 1 ] ).toBe( expandPath( baseDir & '/foo.txt' ) );
            	
			} );
			
            it( "Can apply a UDF", function() {
            	var results = [];
            	globber
            		.setPattern( baseDir & '/**' )
            		.apply( function( path ) {
            			results.append( path );
            		} );
            	
            	expect( results ).toHaveLength( 23 );
            	
			} );
			
            it( "Do a deep search", function() {
            	// Search the entire globber repo (around 600 files)
            				
            	var results = globber
            		.setPattern( expandPath( baseDir & '/../../../../' ) & '**/foo.txt' )
            		.matches();
            	
            	expect( results ).toHaveLength( 1 );
			} );
			
			
                        
        } );
        
    }
}

