import sys.io.File;
import haxe.ds.StringMap;

class InlineYAML {
		
	static function main() : Int {
		var args = Sys.args();
		if (args == null || args.length < 2) {
			Sys.stderr().writeString("expected 2 args but got less. inline-ymal in out");
			return 1;
		}
		
		var text = File.getContent(args[0]);
		
		var inliner = new InlineYAML();
		var inlinedText = inliner.inlineText(text);
		
		File.saveContent(args[1], inlinedText);
		return 0;
	}
	
	public function new() {}
	
	function inlineText(text : String) : String {
		var lines = text.split("\n");
		var reg = ~/(.+): (.+)/;
		var pairs = new StringMap<String>();
	
		for (line in lines) {
			if (reg.match(line)) {
				pairs.set(StringTools.trim(reg.matched(1)), StringTools.trim(reg.matched(2)));
			}
		}
		
		reg = ~/\{\{([\w-]*)\}\}/g;
		
		var changed : Bool = true;
		while (changed) {
			changed = false;
			for (key in pairs.keys()) {
				var value = pairs.get(key);
				var newVal = inlineVars(value, pairs, reg);
				if (newVal != null) {
					pairs.set(key, newVal);
					changed = true;
				}
			}
		}
		
		var inlinedText = "";
		for (key in pairs.keys()) {
			var value = pairs.get(key);
			inlinedText += '$key: $value\n';
		}
		
		return inlinedText;
	}
	
	inline function inlineVars(value : String, usingMap : StringMap<String>, reg : EReg) : String {
		var result : String = value;
		var newVal = reg.map(value, function(r) : String {
			var match = r.matched(1);
			return usingMap.get(match);
		});
		
		return result != newVal ? newVal : null;
	}
}
