component extends="tests.resources.ModuleIntegrationSpec" appMapping="/app" {
	
	function setup() {
		super.setup();
		baseDir = expandPath( '/tests/resources/testFolders' );
		baseDir = getInstance( 'PathPatternMatcher@globber' ).normalizeSlashes( baseDir );
		//applicationStop(); 
	}
	
    function run() {
        describe( "The Globber fluent API", function() {
	        	
	    	beforeEach( function() {
	    		// Create a fresh globber for each test.
				globber = getInstance( 'globber' );
	    	} );
	    	
            it( "process negative ignore", function() {
            	var results = globber
            		.inDirectory( baseDir )
            		.setPattern( '/food' )
            		.setExcludePattern( '/food/unhealthy/*,!/food/unhealthy/arsenic.txt,!/food/unhealthy/lard.txt' )
            		.loose()
            		.matches()
            		.map( function( i ) { return expandPath( i ); } );
        		
            	expect( results ).toHaveLength( 11 );
            	expect( results ).toInclude( expandPath( baseDir & '/food/' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/cake.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/coffee.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/pizza.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/healthy/' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/healthy/fruits.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/healthy/milk.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/healthy/veggies.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/unhealthy/' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/unhealthy/arsenic.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/unhealthy/lard.txt' ) );
			} );
	    	
            it( "process negative ignore in deep dir", function() {
            	var results = globber
            		.inDirectory( baseDir )
            		.setPattern( '#baseDir#/**' )
            		.setExcludePattern( '#baseDir#/*,!#baseDir#/food/unhealthy/arsenic.t?t,!#baseDir#/food/unhealthy/lard.txt,!#baseDir#/foo.txt' )
            		.matches()
            		.map( function( i ) { return expandPath( i ); } );
            	            	
            	expect( results ).toHaveLength( 3 );
            	expect( results ).toInclude( expandPath( baseDir & '/foo.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/unhealthy/arsenic.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/unhealthy/lard.txt' ) );
			} );
	    	
            it( "process negative loose ignore in deep dir", function() {
            	var results = globber
            		.inDirectory( baseDir )
            		.setPattern( '*' )
            		.setExcludePattern( '*,!/food/unhealthy/arsenic.t?t,!/food/unhealthy/lard.txt,!foo.txt,!/bar.txt' )
            		.loose()
            		.matches()
            		.map( function( i ) { return expandPath( i ); } );

            	expect( results ).toHaveLength( 4 );
            	expect( results ).toInclude( expandPath( baseDir & '/foo.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/bar.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/unhealthy/arsenic.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/unhealthy/lard.txt' ) );
			} );
	    	
            it( "Can match a specific path", function() {
            	var results = globber
            		.setPattern( baseDir & '/foo.txt' )
            		.matches()
            		.map( function( i ) { return expandPath( i ); } );
            	
            	expect( results ).toHaveLength( 1 );
            	expect( results[ 1 ] ).toBe( expandPath( baseDir & '/foo.txt' ) );
			} );
	    	
            it( "Can loose match a specific path", function() {
            	var results = globber
            		.inDirectory( baseDir )
            		.setPattern( 'foo.txt' )
            		.loose()
            		.matches()
            		.map( function( i ) { return expandPath( i ); } );
            	
            	expect( results ).toHaveLength( 1 );
            	expect( results[ 1 ] ).toBe( expandPath( baseDir & '/foo.txt' ) );
			} );
	    	
            it( "Can loose match a specific exact path", function() {
            	var results = globber
            		.inDirectory( baseDir )
            		.setPattern( '/foo.txt' )
            		.loose()
            		.matches()
            		.map( function( i ) { return expandPath( i ); } );
            	
            	expect( results ).toHaveLength( 1 );
            	expect( results[ 1 ] ).toBe( expandPath( baseDir & '/foo.txt' ) );
			} );
	    	
            it( "Can match all sub paths", function() {
            	var results = globber
            		.setPattern( baseDir & '/**' )
            		.matches()
            		.map( function( i ) { return expandPath( i ); } );
            		
            	expect( results ).toHaveLength( 23 );
			} );
	    	
            it( "Can get count of matches", function() {
            	var results = globber
            		.setPattern( baseDir & '/**' )
            		.count();
            		
            	expect( results ).toBe( 23 );
			} );
	    	
            it( "Can get count of NO matches", function() {
            	var results = globber
            		.setPattern( baseDir & 'sdfsdfasdf' )
            		.count();
            		
            	expect( results ).toBe( 0 );
			} );
	    	
            it( "Can match extensions in current dir", function() {
            	var results = globber
            		.setPattern( baseDir & '/*.txt' )
            		.matches()
            		.map( function( i ) { return expandPath( i ); } );
            		
            	expect( results ).toHaveLength( 3 );
            	
            	expect( results ).toInclude( expandPath( baseDir & '/foo.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/bar.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/baz.txt' ) );
			} );
	    	
            it( "Can match partial folders and files in current dir", function() {
            	var results = globber
            		.setPattern( baseDir & '/fo*' )
            		.matches()
            		.map( function( i ) { return expandPath( i ); } );
            		
            	expect( results ).toHaveLength( 2 );
            	
            	expect( results ).toInclude( expandPath( baseDir & '/foo.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/' ) );
            	
			} );
	    	
            it( "Can match a file in a sub dir recursivley", function() {
            	var results = globber
            		.setPattern( baseDir & '/**/luis.txt' )
            		.matches()
            		.map( function( i ) { return expandPath( i ); } );
            	expect( results ).toHaveLength( 1 );
            	
            	expect( results[ 1 ] ).toBe( expandPath( baseDir & '/names/luis.txt' ) );
            	
			} );
			
	    	
            it( "Can match a file in a sub dir", function() {
            	var results = globber
            		.setPattern( baseDir & '/*/luis.txt' )
            		.matches()
            		.map( function( i ) { return expandPath( i ); } );
            	expect( results ).toHaveLength( 1 );
            	
            	expect( results[ 1 ] ).toBe( expandPath( baseDir & '/names/luis.txt' ) );
            	
			} );
	    	
            it( "Can match a deep file with loose matching", function() {
            	var results = globber
            		.inDirectory( baseDir )
            		.setPattern( 'luis.txt' )
            		.loose()
            		.matches()
            		.map( function( i ) { return expandPath( i ); } );
            	expect( results ).toHaveLength( 1 );
            	
            	expect( results[ 1 ] ).toBe( expandPath( baseDir & '/names/luis.txt' ) );
            	
			} );
	    	
            it( "leading slash in loose mode only matches root - no results", function() {
            	var results = globber
            		.inDirectory( baseDir )
            		.setPattern( '/luis.txt' )
            		.loose()
            		.matches()
            		.map( function( i ) { return expandPath( i ); } );
            	expect( results ).toHaveLength( 0 );
            	
			} );
	    	
            it( "leading slash in loose mode only matches root", function() {
            	var results = globber
            		.inDirectory( baseDir )
            		.setPattern( '/nam?s' )
            		.loose()
            		.matches()
            		.map( function( i ) { return expandPath( i ); } );
            		
            	expect( results ).toHaveLength( 4 );
            	
            	expect( results ).toInclude( expandPath( baseDir & '/names/' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/names/brad.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/names/gavin.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/names/luis.txt' ) );
            	
			} );
	    	
            it( "leading slash in loose mode only matches root with exclusion", function() {
            	var results = globber
            		.inDirectory( baseDir )
            		.setPattern( '/nam?s' )
            		.setExcludePattern( 'brad.txt' )
            		.loose()
            		.matches()
            		.map( function( i ) { return expandPath( i ); } );

            	expect( results ).toHaveLength( 3 );
            	
            	expect( results ).toInclude( expandPath( baseDir & '/names/' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/names/gavin.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/names/luis.txt' ) );
            	
			} );
			
            it( "Can match all files in a deep dir", function() {
            	var results = globber
            		.setPattern( baseDir & '/food/*' )
            		.matches()
            		.map( function( i ) { return expandPath( i ); } );
            			
            	expect( results ).toHaveLength( 5 );
            	
            	expect( results ).toInclude( expandPath( baseDir & '/food/cake.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/coffee.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/pizza.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/healthy/' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/unhealthy/' ) );
            	
			} );
						
            it( "Can match all files in a deep dir with loose exclude", function() {
            	var results = globber
            		.inDirectory( baseDir )
            		.setPattern( '/food' )
            		.setExcludePattern( 'fruits.txt,unhealthy,coffee.txt' )
            		.loose()
            		.matches()
            		.map( function( i ) { return expandPath( i ); } );
            			
            	expect( results ).toHaveLength( 6 );
            	
            	expect( results ).toInclude( expandPath( baseDir & '/food/' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/cake.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/pizza.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/healthy/' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/healthy/milk.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/healthy/veggies.txt' ) );
            	
			} );
			
            it( "Can match all files in a dir with loose matching", function() {
            	var results = globber
            		.inDirectory( baseDir )
            		.setPattern( 'food' )
            		.loose()
            		.matches()
            		.map( function( i ) { return expandPath( i ); } );
            		
            	expect( results ).toHaveLength( 12 );
            	
            	expect( results ).toInclude( expandPath( baseDir & '/food/' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/cake.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/coffee.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/pizza.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/healthy/' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/healthy/fruits.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/healthy/milk.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/healthy/veggies.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/unhealthy/' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/unhealthy/arsenic.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/unhealthy/lard.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/unhealthy/candy.txt' ) );
            	
			} );
			
            it( "Can match all files in a deep dir with partial name", function() {
            	var results = globber
            		.setPattern( baseDir & '/*d/*.txt' )
            		.matches()
            		.map( function( i ) { return expandPath( i ); } );
            		
            	expect( results ).toHaveLength( 3 );
            	
            	expect( results ).toInclude( expandPath( baseDir & '/food/cake.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/coffee.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/pizza.txt' ) );
            	
			} );
			
            it( "Can match files in a deep dir with question mark in the name", function() {
            	var results = globber
            		.setPattern( baseDir & '/foo?/*.txt' )
            		.matches()
            		.map( function( i ) { return expandPath( i ); } );
            		
            	expect( results ).toHaveLength( 3 );
            	
            	expect( results ).toInclude( expandPath( baseDir & '/food/cake.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/coffee.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/pizza.txt' ) );
            	
			} );
			
            it( "Can have more than one wildcard in path", function() {
            	var results = globber
            		.setPattern( baseDir & '/*/hea?thy/**' )
            		.matches()
            		.map( function( i ) { return expandPath( i ); } );
            	expect( results ).toHaveLength( 4 );
            	
            	expect( results ).toInclude( expandPath( baseDir & '/food/healthy/' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/healthy/fruits.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/healthy/milk.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/healthy/veggies.txt' ) );
            	
			} );
			
            it( "Can have double ** in middle of path", function() {
            	var results = globber
            		.setPattern( baseDir & '/**/hea?thy/*' )
            		.matches()
            		.map( function( i ) { return expandPath( i ); } );
            		
            	expect( results ).toHaveLength( 3 );
            	
            	expect( results ).toInclude( expandPath( baseDir & '/food/healthy/fruits.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/healthy/milk.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/healthy/veggies.txt' ) );
            	
			} );
			
            it( "Can match all files recursivley in a deep dir", function() {
            	var results = globber
            		.setPattern( baseDir & '/food/**' )
            		.matches()
            		.map( function( i ) { return expandPath( i ); } );
            	
            	expect( results ).toHaveLength( 11 );
            	
            	expect( results ).toInclude( expandPath( baseDir & '/food/cake.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/coffee.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/pizza.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/healthy/' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/healthy/fruits.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/healthy/milk.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/healthy/veggies.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/unhealthy/' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/unhealthy/arsenic.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/unhealthy/lard.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/food/unhealthy/candy.txt' ) );
            	
			} );
			
            it( "Can match all files recursivley in a deep dir", function() {
            	var results = globber
            		.setPattern( baseDir & '/f?o.tx?' )
            		.matches()
            		.map( function( i ) { return expandPath( i ); } );
            	
            	expect( results ).toHaveLength( 1 );
            	expect( results[ 1 ] ).toBe( expandPath( baseDir & '/foo.txt' ) );
            	
			} );
			
            it( "Can apply a UDF to an array", function() {
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
            		.setPattern( expandPath( baseDir & '/../../../' ) & '**/foo.txt' )
            		.setExcludePattern( [ expandPath( baseDir & '/../app/' ) & '**', expandPath( baseDir & '/../../../testbox/' ), expandPath( baseDir & '/../../../.git/' ) ] )
            		.matches();

            	expect( results ).toHaveLength( 1 );
			} );
			
            it( "Can get a query back", function() {
            	var results = globber
            		.setPattern( baseDir & '/f?o.tx?' )
            		.asQuery()
            		.matches();
            		
            	expect( results ).toBeQuery();
            	expect( results ).toHaveLength( 1 ); 
            	expect( results[ 'name' ][ 1 ] ).toBe( 'foo.txt' );
            	
			} );
			
            it( "Can apply a UDF to a query", function() {
            	var results = [];
            	globber
            		.setPattern( baseDir & '/**' )
            		.asQuery()
            		.apply( function( row ) {
            			results.append( row.name );
            		} );
            	
            	expect( results ).toHaveLength( 23 );            	
			} );
			
            it( "Can sort results asc", function() {
            	var results = globber
            		.setPattern( baseDir & '/*' )
            		.withSort( 'name asc' )
            		.matches()
            		.map( function( i ) { return expandPath( i ); } );
            		
            	expect( results[ 1 ] ).toBe( expandPath( baseDir & '/bar.txt' ) );
            	expect( results[ 6 ] ).toBe( expandPath( baseDir & '/states/' ) );            	            	
			} );
			
            it( "Can sort results desc", function() {
            	var results = globber
            		.setPattern( baseDir & '/*' )
            		.withSort( 'name desc' )
            		.matches()
            		.map( function( i ) { return expandPath( i ); } );
            		
            	expect( results[ 1 ] ).toBe( expandPath( baseDir & '/states/' ) );
            	expect( results[ 6 ] ).toBe( expandPath( baseDir & '/bar.txt' ) );            	            	
			} );
			
            it( "Can accept array of patterns", function() {
            	var results = globber
            		.setPattern( [ baseDir & '/names/*', baseDir & '/states/*' ] )
            		.matches()
            		.map( function( i ) { return expandPath( i ); } );

            	expect( results ).toHaveLength( 6 );
            	expect( results[ 1 ] ).toBe( expandPath( baseDir & '/names/brad.txt' ) );
            	expect( results[ 6 ] ).toBe( expandPath( baseDir & '/states/texas.txt' ) );            	            	
			} );
			
            it( "Can accept list of patterns", function() {
            	var results = globber
            		.setPattern( "#baseDir#/names/*,#baseDir#/states/*" )
            		.matches()
            		.map( function( i ) { return expandPath( i ); } );
            		
            	expect( results ).toHaveLength( 6 );
            	expect( results[ 1 ] ).toBe( expandPath( baseDir & '/names/brad.txt' ) );
            	expect( results[ 6 ] ).toBe( expandPath( baseDir & '/states/texas.txt' ) );            	            	
			} );
			
            it( "Can remove duplicate matches", function() {
            	var results = globber
            		.setPattern( "#baseDir#/names/*,#baseDir#/names/*" )
            		.matches()
            		.map( function( i ) { return expandPath( i ); } );
            		
            	expect( results ).toHaveLength( 3 );            	            	
			} );
			
            it( "Can ignore empty patterns", function() {
            	var results = globber
            		.setPattern( [ "#baseDir#/names/*", '', '', '' ] )
            		.matches()
            		.map( function( i ) { return expandPath( i ); } );
            		
            	expect( results ).toHaveLength( 3 );            	            	
			} );
			
            it( "Doesn't allow no patterns", function() {
            	expect( function() {
            		globber.matches();
            	} ).toThrow( regex='Cannot glob empty pattern' );            	            	
			} );
			
            it( "Can add pattern to existing list", function() {
            	var results = globber
            		.addPattern( baseDir & '/names/*' )
            		.addPattern( baseDir & '/states/*' )
            		.matches()
            		.map( function( i ) { return expandPath( i ); } );
            		
            	expect( results ).toHaveLength( 6 );
            	expect( results[ 1 ] ).toBe( expandPath( baseDir & '/names/brad.txt' ) );
            	expect( results[ 6 ] ).toBe( expandPath( baseDir & '/states/texas.txt' ) );            	            	
			} );
			
            it( "calculates the base dir", function() {
            	var glob = globber
            		.setPattern( [ baseDir & '/names/*', baseDir & '/states/*', baseDir & '/food' ] );
            		
           		glob.matches();          		
            	            		
            	expect( glob.getBaseDir() ).toBe( baseDir&'/' );            	
            } );
        
			it( "Can exclude a single path", function() {
				var results = globber
					.setPattern( baseDir & '/names/**' )
					.setExcludePattern( baseDir & '/names/brad.txt' )
						.matches()
						.map( function( i ) { return expandPath( i ); } );
				
				expect( results ).toHaveLength( 2 );
            	expect( results ).toInclude( expandPath( baseDir & '/names/gavin.txt' ) );
            	expect( results ).toInclude( expandPath( baseDir & '/names/luis.txt' ) );
			} );
        
			it( "Can exclude a folder", function() {
				var results = globber
					.setPattern( baseDir & '/**' )
					.setExcludePattern( baseDir & '/names/**' )
					.matches()
					.map( function( i ) { return expandPath( i ); } );

				expect( results ).toHaveLength( 19 );
			} );
        
			it( "Can exclude an array", function() {
				var results = globber
					.setPattern( baseDir & '/**' )
					.setExcludePattern( [ baseDir & '/names/**', baseDir & '/food/**' ] )
						.matches()
						.map( function( i ) { return expandPath( i ); } );

				expect( results ).toHaveLength( 7 );
			} );
        
			it( "Can add single excludes", function() {
				var results = globber
					.setPattern( baseDir & '/**' )
					.addExcludePattern( baseDir & '/names/**' )
						.matches()
						.map( function( i ) { return expandPath( i ); } );

				expect( results ).toHaveLength( 19 );
			} );
        
			it( "Can ignore invalid sorts", function() {
				globber
					.setSort( 'name asc' );
				expect( globber.getCleanSort() ).toBe( 'name asc' );
				
				globber
					.setSort( 'name asc, directory desc' );
				expect( globber.getCleanSort() ).toBe( 'name asc, directory desc' );
				
				globber
					.setSort( ' name , directory ' );
				expect( globber.getCleanSort() ).toBe( ' name , directory ' );
				
				globber
					.setSort( 'name desk' );
				expect( globber.getCleanSort() ).toBe( 'type, name' );
				
				globber
					.setSort( 'name asc foo' );
				expect( globber.getCleanSort() ).toBe( 'type, name' );
				
				globber
					.setSort( 'bean desc' );
				expect( globber.getCleanSort() ).toBe( 'type, name' );
				
				
			} );
						
            it( "Can matching paths", function() {
            	toPath = expandPath( '/tests/resources/tmpFolder' );
            	if( directoryExists( toPath ) ) {
            		directoryDelete( toPath, true )
            	}
            	try {
	            	var results = globber
	            		.inDirectory( baseDir & '/food' )
	            		.loose()
	            		.copyTo( toPath );
	            		
	            	var results = directoryList( toPath, true );
					
	            	expect( results ).toHaveLength( 11 );
	            	
	            	expect( results ).toInclude( expandPath( toPath & '/cake.txt' ) );
	            	expect( results ).toInclude( expandPath( toPath & '/coffee.txt' ) );
	            	expect( results ).toInclude( expandPath( toPath & '/pizza.txt' ) );
	            	expect( results ).toInclude( expandPath( toPath & '/healthy' ) );
	            	expect( results ).toInclude( expandPath( toPath & '/healthy/fruits.txt' ) );
	            	expect( results ).toInclude( expandPath( toPath & '/healthy/milk.txt' ) );
	            	expect( results ).toInclude( expandPath( toPath & '/healthy/veggies.txt' ) );
	            	expect( results ).toInclude( expandPath( toPath & '/unhealthy' ) );
	            	expect( results ).toInclude( expandPath( toPath & '/unhealthy/arsenic.txt' ) );
	            	expect( results ).toInclude( expandPath( toPath & '/unhealthy/lard.txt' ) );
	            	expect( results ).toInclude( expandPath( toPath & '/unhealthy/candy.txt' ) );
	            	
            	} finally {
	            	if( directoryExists( toPath ) ) {
	            		directoryDelete( toPath, true )
	            	}	
            	}
            	
            	
			} );
		
        } );
        
    }
}

