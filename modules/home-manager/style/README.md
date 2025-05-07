# strixos.style

options for styling system

## themeDir

the themeDir is a way to easaly switch themes.
It may contain the folowing files:

- theme.toml (required -> the actual theme)
- background.png

## theme.toml

```toml
polarity = <string> # theme polarity (strixos.style.stylix.theme.polarity)
[font]
name = <string> #name of the font
package = <string> # the name of the font package in nixpkgs
[cursor]
name = <string> #name of the cursor theme
package <string> # the name of the package in nixpkgs
size = <int> # the cursor size
[icons]
name = <string> #name of the icon theme
package <string> # the name of the package in nixpkgs
[colors] # theme colors as specified by stylix (strixos.style.stylix.theme.scheme)
base00 = <string> 
base01 = <string> 
base02 = <string> 
base03 = <string> 
base04 = <string> 
base05 = <string> 
base06 = <string> 
base07 = <string> 
base08 = <string> 
base09 = <string> 
base0A = <string> 
base0B = <string> 
base0C = <string> 
base0D = <string> 
base0E = <string> 
base0F = <string> 
```
