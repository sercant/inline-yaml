# inline-yaml
Takes an input file to replace, and outputs inlined version of the input to the output file.

Currently only supports single depth.

An example input file:
```yaml
fizz: buzz
foo: bar

fizz-foo: {{fizz}}-{{foo}}
```

Outputs:
```yaml
fizz: buzz
foo: bar

fizz-foo: buzz-bar
```

Usage: 
```
inline-yaml path/to/input/file path/to/output/file
```
