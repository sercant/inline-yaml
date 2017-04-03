# inline-yaml
Takes an input file to replace, and outputs inlined version of the input to the output file.

Currently only supports single depth.

An example input file:
```yaml
fizz: buzz
foo: bar

fizz-foo: {{fizz}}-{{foo}}
fizz-foo-hey: {{fizz-foo}}-ho
```

Outputs:
```yaml
fizz: buzz
foo: bar

fizz-foo: buzz-bar
fizz-foo-hey: buzz-bar-ho
```

Usage: 
```
inline-yaml path/to/input/file path/to/output/file
```
