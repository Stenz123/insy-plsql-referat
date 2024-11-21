# Marp Presentation Template
This is a template for presentations with [Marp](https://github.com/marp-team/marp)

## Themes
For other Themes just see: [Marp Themes](https://github.com/marp-team/marp-core/blob/main/themes/README.md)
For external themes like [Dracula](https://github.com/dracula/marp), just download the theme add the ```--theme <Path to Theme.css>``` flag to the command.

## Compile the presentation
### Compile Marp in Docker with watch 
```Bash
docker run --rm --init -v $PWD:/home/marp/app -e LANG=$LANG -p 8080:8080 -p 37717:37717 marpteam/marp-cli -w --html ./slides.md
```
https://hub.docker.com/r/marpteam/marp-cli/

### Compile Marp with cli tool
```Bash
marp -w --html ./slides.md
```
[Install cli tool](https://github.com/marp-team/marp-cli?tab=readme-ov-file#install)
