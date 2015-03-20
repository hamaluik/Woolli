import massive.munit.TestSuite;

import com.blazingmammothgames.woolli.core.ComponentTest;
import com.blazingmammothgames.woolli.core.DemandsTest;
import com.blazingmammothgames.woolli.core.EntityStateMachineTest;
import com.blazingmammothgames.woolli.core.EntityStateTest;
import com.blazingmammothgames.woolli.core.EntityTest;
import com.blazingmammothgames.woolli.core.ESExceptionTest;
import com.blazingmammothgames.woolli.core.UniverseTest;

/**
 * Auto generated Test Suite for MassiveUnit.
 * Refer to munit command line tool for more information (haxelib run munit)
 */

class TestSuite extends massive.munit.TestSuite
{		

	public function new()
	{
		super();

		add(com.blazingmammothgames.woolli.core.ComponentTest);
		add(com.blazingmammothgames.woolli.core.DemandsTest);
		add(com.blazingmammothgames.woolli.core.EntityStateMachineTest);
		add(com.blazingmammothgames.woolli.core.EntityStateTest);
		add(com.blazingmammothgames.woolli.core.EntityTest);
		add(com.blazingmammothgames.woolli.core.ESExceptionTest);
		add(com.blazingmammothgames.woolli.core.UniverseTest);
	}
}
