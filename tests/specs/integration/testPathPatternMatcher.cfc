component extends="tests.resources.ModuleIntegrationSpec" appMapping="/app" {
	
	function setup() {
		super.setup();
		
		PathPatternMatcher = getInstance( 'PathPatternMatcher@globber' );
	}
	
    function run() {
    	
        describe( "Integration Specs", function() {
        	
            it( "can run integration specs with the module activated", function() {
                expect( getController().getModuleService().isModuleRegistered( "globber" ) ).toBeTrue();
            } );
            
        } );
    	
        describe( "Path pattern matcher", function() {
        	
            it( "foo will match any file or folder in the directory tree", function() {
            	
				// End a pattern with a slash to only match a directory. Start a pattern with a slash to start in the root.
				assertTrue( PathPatternMatcher.matchPattern( 'a', 'a/' ) );
				assertTrue( PathPatternMatcher.matchPattern( 'a', 'a/b/c/d/' ) );
				assertTrue( PathPatternMatcher.matchPattern( 'b', 'a/b/c/d/' ) );
				assertTrue( PathPatternMatcher.matchPattern( 'c', 'a/b/c/d/' ) );
				assertTrue( PathPatternMatcher.matchPattern( 'd', 'a/b/c/d/' ) );
				
				assertTrue( PathPatternMatcher.matchPattern( 'a', 'a' ) );
				assertTrue( PathPatternMatcher.matchPattern( 'a', 'a/b/c/d' ) );
				assertTrue( PathPatternMatcher.matchPattern( 'b', 'a/b/c/d' ) );
				assertTrue( PathPatternMatcher.matchPattern( 'c', 'a/b/c/d' ) );
				assertTrue( PathPatternMatcher.matchPattern( 'd', 'a/b/c/d' ) );
				
            } );
            
            
            it( "/foo will only match a file or folder in the root", function() {
				
				assertTrue( PathPatternMatcher.matchPattern( '/a', 'a/' ) );
				assertTrue( PathPatternMatcher.matchPattern( '/a', 'a/b/c/d/' ) );
				assertFalse( PathPatternMatcher.matchPattern( '/b', 'a/b/c/d/' ) );
				assertTrue( PathPatternMatcher.matchPattern( '/a/b', 'a/b/c/d/' ) );
				assertFalse( PathPatternMatcher.matchPattern( '/d', 'a/b/c/d/' ) );
				
				assertTrue( PathPatternMatcher.matchPattern( '/a', 'a' ) );
				assertTrue( PathPatternMatcher.matchPattern( '/a', 'a/b/c/d' ) );
				assertFalse( PathPatternMatcher.matchPattern( '/b', 'a/b/c/d' ) );
				assertTrue( PathPatternMatcher.matchPattern( '/a/b', 'a/b/c/d' ) );
				assertFalse( PathPatternMatcher.matchPattern( '/d', 'a/b/c/d' ) );
            } );
            
            
            it( "foo/ will only match a directory anywhere in the directory tree", function() {
				assertTrue( PathPatternMatcher.matchPattern( 'a/', 'a/' ) );
				assertTrue( PathPatternMatcher.matchPattern( 'a/', 'a/b/c/d/' ) );
				assertTrue( PathPatternMatcher.matchPattern( 'b/', 'a/b/c/d/' ) );
				assertTrue( PathPatternMatcher.matchPattern( 'c/', 'a/b/c/d/' ) );
				assertTrue( PathPatternMatcher.matchPattern( 'd/', 'a/b/c/d/' ) );
				
				assertFalse( PathPatternMatcher.matchPattern( 'a/', 'a' ) );
				assertTrue( PathPatternMatcher.matchPattern( 'a/', 'a/b/c/d' ) );
				assertTrue( PathPatternMatcher.matchPattern( 'b/', 'a/b/c/d' ) );
				assertTrue( PathPatternMatcher.matchPattern( 'c/', 'a/b/c/d' ) );
				assertFalse( PathPatternMatcher.matchPattern( 'd/', 'a/b/c/d' ) );
				
            } );
            
            
            it( "/foo/ will only match a folder in the root", function() {
						
				assertTrue( PathPatternMatcher.matchPattern( '/a/', 'a/' ) );
				assertTrue( PathPatternMatcher.matchPattern( '/a/', 'a/b/c/d/' ) );
				assertFalse( PathPatternMatcher.matchPattern( '/b/', 'a/b/c/d/' ) );
				assertFalse( PathPatternMatcher.matchPattern( '/c/', 'a/b/c/d/' ) );
				assertFalse( PathPatternMatcher.matchPattern( '/d/', 'a/b/c/d/' ) );
				
				assertFalse( PathPatternMatcher.matchPattern( '/a/', 'a' ) );
				assertTrue( PathPatternMatcher.matchPattern( '/a/', 'a/b/c/d' ) );
				assertFalse( PathPatternMatcher.matchPattern( '/b/', 'a/b/c/d' ) );
				assertFalse( PathPatternMatcher.matchPattern( '/c/', 'a/b/c/d' ) );
				assertFalse( PathPatternMatcher.matchPattern( '/d/', 'a/b/c/d' ) );
            } );
            
            
            it( "foo* will match any file or folder starting with 'foo'", function() {
				
				// Use a single * to match zero or more characters INSIDE a file or folder name (won't match a slash)
				assertTrue( PathPatternMatcher.matchPattern( 'a*', 'a/' ) );
				assertTrue( PathPatternMatcher.matchPattern( 'a*', 'abc/' ) );
				assertFalse( PathPatternMatcher.matchPattern( 'a*', 'xyz/' ) );
				assertTrue( PathPatternMatcher.matchPattern( 'a*', 'a/b/c/d/' ) );
				assertTrue( PathPatternMatcher.matchPattern( 'a*', 'abc/b/c/d/' ) );
				assertTrue( PathPatternMatcher.matchPattern( 'b*', 'a/b/c/d/' ) );
				assertTrue( PathPatternMatcher.matchPattern( 'b*', 'a/bxyz/c/d/' ) );
				assertTrue( PathPatternMatcher.matchPattern( 'd*', 'a/b/c/d/' ) );
				assertTrue( PathPatternMatcher.matchPattern( 'd*', 'a/b/c/def/' ) );
				
				assertTrue( PathPatternMatcher.matchPattern( 'a*', 'a' ) );
				assertTrue( PathPatternMatcher.matchPattern( 'a*', 'abc' ) );
				assertTrue( PathPatternMatcher.matchPattern( 'a*', 'a/b/c/d' ) );
				assertTrue( PathPatternMatcher.matchPattern( 'a*', 'abc/b/c/d' ) );
				assertTrue( PathPatternMatcher.matchPattern( 'b*', 'a/b/c/d' ) );
				assertTrue( PathPatternMatcher.matchPattern( 'b*', 'a/bxyz/c/d' ) );
				assertTrue( PathPatternMatcher.matchPattern( 'd*', 'a/b/c/d' ) );
				assertTrue( PathPatternMatcher.matchPattern( 'd*', 'a/b/c/def' ) );
            } );
            
            
            it( "foo*.txt will match any file or folder starting with 'foo' and ending with .txt", function() {
				assertTrue( PathPatternMatcher.matchPattern( 'a*.txt', 'a.txt/' ) );
				assertTrue( PathPatternMatcher.matchPattern( 'a*.txt', 'abc.txt/' ) );
				assertFalse( PathPatternMatcher.matchPattern( 'a*.txt', 'xyz.txt/' ) );
				assertTrue( PathPatternMatcher.matchPattern( 'a*z', 'az/b/c/d/' ) );
				assertTrue( PathPatternMatcher.matchPattern( 'a*z', 'abcz/b/c/d/' ) );
				assertTrue( PathPatternMatcher.matchPattern( 'b*z', 'a/bz/c/d/' ) );
				assertTrue( PathPatternMatcher.matchPattern( 'b*z', 'a/bxyz/c/d/' ) );
				assertTrue( PathPatternMatcher.matchPattern( 'd*z', 'a/b/c/dz/' ) );
				assertTrue( PathPatternMatcher.matchPattern( 'd*z', 'a/b/c/defz/' ) );
				
				assertTrue( PathPatternMatcher.matchPattern( 'a*.txt', 'a.txt' ) );
				assertTrue( PathPatternMatcher.matchPattern( 'a*.txt', 'abc.txt' ) );
				assertFalse( PathPatternMatcher.matchPattern( 'a*.txt', 'xyz.txt' ) );
				assertTrue( PathPatternMatcher.matchPattern( 'a*z', 'az/b/c/d' ) );
				assertTrue( PathPatternMatcher.matchPattern( 'a*z', 'abcz/b/c/d' ) );
				assertTrue( PathPatternMatcher.matchPattern( 'b*z', 'a/bz/c/d' ) );
				assertTrue( PathPatternMatcher.matchPattern( 'b*z', 'a/bxyz/c/d' ) );
				assertTrue( PathPatternMatcher.matchPattern( 'd*z', 'a/b/c/dz' ) );
				assertTrue( PathPatternMatcher.matchPattern( 'd*z', 'a/b/c/defz' ) );
				
            } );
            
            
            it( "*foo will match any file or folder ending with 'foo'", function() {
				assertTrue( PathPatternMatcher.matchPattern( '*a.txt', 'a.txt/' ) );
				assertTrue( PathPatternMatcher.matchPattern( '*a.txt', 'cba.txt/' ) );
				assertFalse( PathPatternMatcher.matchPattern( '*a.txt', 'xyz.txt/' ) );
				assertTrue( PathPatternMatcher.matchPattern( '*a', 'a/b/c/d/' ) );
				assertTrue( PathPatternMatcher.matchPattern( '*xyz', 'xyz/b/c/d/' ) );
				assertTrue( PathPatternMatcher.matchPattern( '*xyz', 'abcxyz/b/c/d/' ) );
				assertTrue( PathPatternMatcher.matchPattern( '*xyz', 'a/xyz/c/d/' ) );
				assertTrue( PathPatternMatcher.matchPattern( '*xyz', 'a/abcxyz/c/d/' ) );
				assertTrue( PathPatternMatcher.matchPattern( '*xyz', 'a/b/c/xyz/' ) );
				assertTrue( PathPatternMatcher.matchPattern( '*xyz', 'a/b/c/abcxyz/' ) );
				
				assertTrue( PathPatternMatcher.matchPattern( '*a.txt', 'a.txt' ) );
				assertTrue( PathPatternMatcher.matchPattern( '*a.txt', 'cba.txt' ) );
				assertFalse( PathPatternMatcher.matchPattern( '*a.txt', 'xyz.txt' ) );
				assertTrue( PathPatternMatcher.matchPattern( '*a', 'a/b/c/d' ) );
				assertTrue( PathPatternMatcher.matchPattern( '*xyz', 'xyz/b/c/d' ) );
				assertTrue( PathPatternMatcher.matchPattern( '*xyz', 'abcxyz/b/c/d' ) );
				assertTrue( PathPatternMatcher.matchPattern( '*xyz', 'a/xyz/c/d' ) );
				assertTrue( PathPatternMatcher.matchPattern( '*xyz', 'a/abcxyz/c/d' ) );
				assertTrue( PathPatternMatcher.matchPattern( '*xyz', 'a/b/c/xyz' ) );
				assertTrue( PathPatternMatcher.matchPattern( '*xyz', 'a/b/c/abcxyz' ) );
				
            } );
            
            
            it( "a/*/z will match a/b/z but not a/b/c/z", function() {
				assertTrue( PathPatternMatcher.matchPattern( 'a/*/z', 'a/b/z/' ) );
				assertFalse( PathPatternMatcher.matchPattern( 'a/*/z', 'a/b/c/z/' ) );
				assertTrue( PathPatternMatcher.matchPattern( '/*/z', 'a/z/' ) );
				assertTrue( PathPatternMatcher.matchPattern( '/*/z', 'a/z/foo/' ) );
				assertTrue( PathPatternMatcher.matchPattern( '/a/*', 'a/b/' ) );
				
				assertTrue( PathPatternMatcher.matchPattern( 'a/*/z', 'a/b/z/' ) );
				assertFalse( PathPatternMatcher.matchPattern( 'a/*/z', 'a/b/c/z/' ) );
				assertTrue( PathPatternMatcher.matchPattern( '/*/z', 'a/z/' ) );
				assertTrue( PathPatternMatcher.matchPattern( '/*/z', 'a/z/foo/' ) );
				assertTrue( PathPatternMatcher.matchPattern( '/a/*', 'a/b/' ) );
				
            } );
            
            
            it( "a/**/z will match a/z and a/b/z and a/b/c/z", function() {
				// Use a double ** to match zero or more characters including slashes. This allows a pattern to span directories
				assertTrue( PathPatternMatcher.matchPattern( 'a/**/z', 'a/b/z/' ) );
				assertTrue( PathPatternMatcher.matchPattern( 'a/**/z', 'a/z/' ) );
				assertTrue( PathPatternMatcher.matchPattern( 'a/**/z', 'a/b/c/z/' ) );
				assertTrue( PathPatternMatcher.matchPattern( '/**/z', 'a/z/' ) );
				assertTrue( PathPatternMatcher.matchPattern( '/**/z', 'a/b/c/z/' ) );
				assertTrue( PathPatternMatcher.matchPattern( '/**/z', 'a/z/foo/' ) );
				assertTrue( PathPatternMatcher.matchPattern( '/**/z', 'a/b/c/z/foo/' ) );
				assertTrue( PathPatternMatcher.matchPattern( '/a/**', 'a/b/' ) );
				assertTrue( PathPatternMatcher.matchPattern( '/a/**', 'a/b/c/d/' ) );
				assertTrue( PathPatternMatcher.matchPattern( '**/foo', 'foo/' ) );
				
				assertTrue( PathPatternMatcher.matchPattern( '/**/a*.txt', 'foo/bar/anvil.txt' ) );
				assertFalse( PathPatternMatcher.matchPattern( '/**/a*.txt', 'foo/bar/trap.txt' ) );
				
				assertTrue( PathPatternMatcher.matchPattern( '**/foo/bar', 'foo/bar/' ) );
				assertTrue( PathPatternMatcher.matchPattern( '**/foo/bar', 'a/b/foo/bar/' ) );
				
				assertTrue( PathPatternMatcher.matchPattern( 'a/**/z', 'a/b/z' ) );
				assertTrue( PathPatternMatcher.matchPattern( 'a/**/z', 'a/z' ) );
				assertTrue( PathPatternMatcher.matchPattern( 'a/**/z', 'a/b/c/z' ) );
				assertTrue( PathPatternMatcher.matchPattern( '/**/z', 'a/z' ) );
				assertTrue( PathPatternMatcher.matchPattern( '/**/z', 'a/b/c/z' ) );
				assertTrue( PathPatternMatcher.matchPattern( '/**/z', 'a/z/foo' ) );
				assertTrue( PathPatternMatcher.matchPattern( '/**/z', 'a/b/c/z/foo' ) );
				assertTrue( PathPatternMatcher.matchPattern( '/a/**', 'a/b' ) );
				assertTrue( PathPatternMatcher.matchPattern( '/a/**', 'a/b/c/d' ) );
				assertTrue( PathPatternMatcher.matchPattern( '**/foo', 'foo' ) );
				assertTrue( PathPatternMatcher.matchPattern( '**/foo/bar', 'foo/bar' ) );
				assertTrue( PathPatternMatcher.matchPattern( '**/foo/bar', 'a/b/foo/bar' ) );
            } );
            
            
            it( "Normalize slashes", function() {
				assertTrue( PathPatternMatcher.matchPattern( '/a', 'a\' ) );
				assertTrue( PathPatternMatcher.matchPattern( '/a', 'a\b/c\d/' ) );
				assertFalse( PathPatternMatcher.matchPattern( '\b', 'a/b/c/d/' ) );
				assertTrue( PathPatternMatcher.matchPattern( '/a/b', 'a/b/c/d/' ) );
				assertFalse( PathPatternMatcher.matchPattern( '\d', 'a\b\c\d\' ) );
				
				assertTrue( PathPatternMatcher.matchPattern( '\a', 'a' ) );
				assertTrue( PathPatternMatcher.matchPattern( '\a', 'a\b/c/d' ) );
				assertFalse( PathPatternMatcher.matchPattern( '/b', 'a/b/c/d' ) );
				assertTrue( PathPatternMatcher.matchPattern( '/a\b', 'a/b/c\d' ) );
				assertFalse( PathPatternMatcher.matchPattern( '/d', 'a\b\c\d' ) );
				
            } );
            
            
            it( "question mark matches single non-slash char", function() {
				assertTrue( PathPatternMatcher.matchPattern( '/h?t', 'hat' ) );
				assertFalse( PathPatternMatcher.matchPattern( '/h?t', 'ham' ) );
				assertFalse( PathPatternMatcher.matchPattern( '/h?t', 'h/t' ) );
				
            } );
            
            
            it( "handle an array of patterns", function() {
				
				assertTrue( PathPatternMatcher.matchPatterns(
					[
						'a/b/c/foo.txt',
						'box.json',
						'/logs'
					],
					'box.json'
				) );
				
				assertFalse( PathPatternMatcher.matchPatterns(
					[
						'a/b/c/foo.txt',
						'box.json',
						'/logs'
					],
					'ColdBox.cfc'
				) );
            } );
                        
        } );
        
    }
}

