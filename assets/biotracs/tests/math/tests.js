//Test bioviz.diag
QUnit.test( "hello test", function( assert ) {
	M = bioviz.diag(3)
	assert.ok( M[1][1] == 1, "Passed!" );
});