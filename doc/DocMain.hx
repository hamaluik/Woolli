package ;

import haxe.rtti.Meta;

class GeneralMeta
{
	public var description:String = "";

	public function new() {}
}

class ClassMeta extends GeneralMeta
{
	public var author:String = "";

	public function new() {super();}
}

class FieldMeta extends GeneralMeta
{
	public function new() {super();}
}

class ClassInfo
{
	public var packageName:String = "";
	public var superName:String = "";
	public var className:String = "";

	public var meta:ClassMeta = null;

	public var methods:Map<String, FieldMeta> = new Map<String, FieldMeta>();
	public var properties:Map<String, FieldMeta> = new Map<String, FieldMeta>();

	public function new() {}
	public function setNames(fullname:String):Void
	{
		var lastDot:Int = fullname.lastIndexOf(".");
		if(lastDot == -1)
		{
			packageName = "";
			className = fullname;
		}
		else
		{
			packageName = fullname.substr(0, lastDot);
			className = fullname.substr(lastDot + 1);
		}
	}
}

class DocMain
{
	static function main()
	{
		var classList:List<ClassInfo> = new List<ClassInfo>();
		CompileTime.importPackage("com.blazingmammothgames.woolli");
		var classes = CompileTime.getAllClasses("com.blazingmammothgames.woolli");
		for(cls in classes)
		{
				var className:String = Type.getClassName(cls);

				var classInfo:ClassInfo = new ClassInfo();
				classInfo.setNames(className);

				/*if(classInfo.className != "S_Acceleration")
					continue;*/

				var classDocMeta:ClassMeta = new ClassMeta();
				classInfo.meta = classDocMeta;

				// see if there is any meta data on this class
				// if so, populate it
				var metaData = Meta.getType(cls);
				try
				{
					classDocMeta.author = metaData.author[0];
					classDocMeta.description = metaData.description[0];	
				}
				catch(exc:String) {}

				// create an instance of the object without having to call it's constructor
				var instance = Type.createEmptyInstance(cls);

				// get all the non-static fields of the class
				var instanceFields = Type.getInstanceFields(cls);

				var existingMetaMap:Map<String, FieldMeta> = new Map<String, FieldMeta>();
				var metaFields = Meta.getFields(cls);
				for(fieldName in Reflect.fields(metaFields))
				{
					var thisFieldMeta = Reflect.field(metaFields, fieldName);
					var fieldMeta = new FieldMeta();
					if(Reflect.hasField(thisFieldMeta, "description"))
						fieldMeta.description = thisFieldMeta.description[0];
					existingMetaMap.set(fieldName, fieldMeta);
				}

				// figure out which are methods and which aren't
				for(fieldName in instanceFields)
				{
					// get the actual field
					var field = Reflect.field(instance, fieldName);

					// create a meta data for it
					var fieldMeta:FieldMeta = null;
					if(existingMetaMap.exists(fieldName))
						fieldMeta = existingMetaMap.get(fieldName);
					else
						fieldMeta = new FieldMeta();
					if(Reflect.isFunction(field))
					{
						classInfo.methods.set(fieldName, fieldMeta);
					}
					else
					{
						classInfo.properties.set(fieldName, fieldMeta);
					}
				}

				classList.push(classInfo);
		}

		//Sys.println("");
		for(ci in classList)
		{
			Sys.println(ci.className + " (by " + ci.meta.author + "): " + ci.meta.description);
			for(propertyName in ci.properties.keys())
			{
				if(ci.properties.get(propertyName).description != "")
					Sys.println("  " + propertyName + " (" + ci.properties.get(propertyName).description + ")");
				else
					Sys.println("  " + propertyName);
			}
			for(methodName in ci.methods.keys())
			{
				if(ci.methods.get(methodName).description != "")
					Sys.println("  " + methodName + " (" + ci.methods.get(methodName).description + ")");
				else
					Sys.println("  " + methodName);
			}
			Sys.println("");
		}
	}
}