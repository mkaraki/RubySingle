# Ruby Single
Combine ruby files.

## Usage
```
PS> rubysingle.ps1 <Startup Ruby File> <Output Ruby path>
```

## Supported
- `require "<library name>"`: Load shared lib.
- `require '<library name>'`: Load shared lib.
- `require_relative "<path>"`: Load another Ruby file.
- `require_relative '<path>'`: Load another Ruby file.

## Non Supported
- `require` or `require_relative` within space.
- File or library name contains `'`.
- File or library name contains space.

## Change
- `require` quote will change to `'`.