# strixos.style

options for styling system

## themeDir

the themeDir is a way to easaly switch themes.
It may contain the folowing files:

- theme.toml (required -> the actual theme)
- background.png
- home.nix (extra home manager config)
- theme.nix (extra normal config)

## theme.toml

```toml
polarity = string # theme polarity (strixos.style.stylix.theme.polarity)
[colors] # theme colors as specified by stylix (strixos.style.stylix.theme.scheme)
base00 = string 
base01 = string 
base02 = string 
base03 = string 
base04 = string 
base05 = string 
base06 = string 
base07 = string 
base08 = string 
base09 = string 
base0A = string 
base0B = string 
base0C = string 
base0D = string 
base0E = string 
base0F = string 
```
