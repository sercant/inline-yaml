import sys.io.File;

typedef Pair = {
	key : String,
	value : String
}

class InlineYAML {
	
	static function main() : Int {
		var args = Sys.args();
		if (args == null || args.length < 2) {
			Sys.stderr().writeString("expected 2 args. in out");
			return 1;
		}
		
		var text = File.getContent(args[0]);
		var lines = text.split("\n");
		var reg = ~/(.+): (.+)/;
		var pairs = new Array<Pair>();
		
		for (line in lines) {
			if (reg.match(line)) {
				var pair = {
					key: StringTools.trim(reg.matched(1)),
					value: StringTools.trim(reg.matched(2))
				};
				pairs.push(pair);
			}
		}
		
		reg = ~/\{\{([\w-]*)\}\}/g;
		
		inline function getPairByKey(key : String, pairs : Array<Pair>) : Pair {
			var result : Pair = null;
			for (pair in pairs) {
				if (pair.key == key) {
					result = pair;
				}
			}
			return result;
		};
		
		var inlinedText = "";
		for (pair in pairs) {
			var key = pair.key;
			var value = pair.value;
			var newVal = reg.map(value, function(r) : String {
				var match = r.matched(1);
				return getPairByKey(match, pairs).value;
			});
			
			inlinedText += '$key: $newVal\n';
		}
		
		File.saveContent(args[1], inlinedText);
		return 0;
	}
}
