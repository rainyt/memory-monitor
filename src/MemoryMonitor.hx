import haxe.ds.WeakMap;

/**
 * 内存监视器，目前暂仅支持JS
 */
class MemoryMonitor {
	/**
	 * 一个弱引用的Map
	 */
	#if js
	private var _map:Map<WeakRef, String> = new Map();
	#else
	private var _map:WeakMap<Dynamic, String> = new WeakMap();
	#end

	/**
	 * 建立一个内存监视管理器
	 */
	public function new() {}

	/**
	 * 观察某一个对象
	 * @param obj 
	 */
	public function watch(obj:Dynamic):Void {
		var c = Type.getClass(obj);
		var cname = Type.getClassName(c);
		_map.set(#if js new WeakRef(obj) #else obj #end, cname);
	}

	/**
	 * 停止观察
	 * @param obj 
	 */
	public function unwatch(obj:Dynamic):Void {
		var c = Type.getClass(obj);
		var cname = Type.getClassName(c);
		for (key => value in _map) {
			if (value == cname) {
				_map.remove(key);
			}
		}
	}

	/**
	 * 将内存状况输出
	 * @return String
	 */
	public function log():String {
		var logs:Array<{
			name:String,
			counts:Int
		}> = [];
		var maps:Map<String, Int> = [];
		for (key => value in _map) {
			#if js
			var isAvailable = key.deref() != null;
			if (!isAvailable) {
				_map.remove(key);
				continue;
			}
			#end
			if (!maps.exists(value)) {
				maps.set(value, 0);
			}
			maps.set(value, maps.get(value) + 1);
		}
		for (key => value in maps) {
			logs.push({
				name: key,
				counts: value
			});
		}
		logs.sort((a, b) -> a.counts > b.counts ? -1 : 1);
		var msg = [];
		for (item in logs) {
			msg.push(item.name + "(" + item.counts + ")");
		}
		return "### MemoryManager\n" + msg.join("\n");
	}
}

#if js
@:native("WeakRef") extern class WeakRef {
	public function new(element:Dynamic):Void;
	public function deref():Dynamic;
}
#end
