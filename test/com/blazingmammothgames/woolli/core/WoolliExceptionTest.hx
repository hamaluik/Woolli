package com.blazingmammothgames.woolli.core;

import massive.munit.Assert;
import com.blazingmammothgames.woolli.core.WoolliException;

class WoolliExceptionTest 
{
	var instance:WoolliException; 
	
	public function new() 
	{
		
	}
	
	@BeforeClass
	public function beforeClass():Void
	{
	}
	
	@AfterClass
	public function afterClass():Void
	{
	}
	
	@Before
	public function setup():Void
	{
		instance = new WoolliException("Test message", true);
	}
	
	@After
	public function tearDown():Void
	{
	}
	
	@Test
	public function messageGetsSet():Void
	{
		Assert.areEqual(instance.message, "Test message");
	}
	
	@Test
	public function canIgnoreGetsSet():Void
	{
		Assert.areEqual(instance.canIgnore, true);
	}
	
	@Test
	public function constructsIgnorableString():Void
	{
		Assert.areEqual("Woolli Exception: Test message [can ignore]", instance.toString());
	}
	
	@Test
	public function constructsNonignorableString():Void
	{
		var exc:WoolliException = new WoolliException("Test message", false);
		Assert.areEqual("Woolli Exception: Test message [non-recoverable]", exc.toString());
	}
}