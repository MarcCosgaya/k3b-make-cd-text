# k3b-make-cd-text
A bash script for generating CD-Text of a K3B project from filenames.

## Use
```
./make_cd_text.sh <project file>
```
This will parse the .k3b file and generate the CD-Text from the filenames. Filename format must be `artist - song.format`. Note that this will only change the CD-Text of the tracks and not the project's.

## Dependencies
`zip` and `unzip`.
