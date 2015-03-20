package com.blazingmammothgames.woolli.core;

import massive.munit.Assert;
import com.blazingmammothgames.woolli.core.ESException;

class ESExceptionTest 
{
	var instance:ESException; 
	
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
		instance = new ESException("Test message", true);
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
		Assert.areEqual("ESException: Test message [can ignore]", instance.toString());
	}
	
	@Test
	public function constructsNonignorableString():Void
	{
		var exc:ESException = new ESException("Test message", false);
		Assert.areEqual("ESException: Test message [non-recoverable]", exc.toString());
	}
}