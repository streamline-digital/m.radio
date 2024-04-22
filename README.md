# m.radio

## Description

The `radio.sh` script generates and plays a playlist of audio tracks matching on genre, year, and release format. 

It is intended operate on a specifically structured library of audio files and may not be generally useful.

## Usage

In the parent directory the script can be executed using the following command:

```bash

sh radio.sh <library_path> <number_of_tracks> <genre> <year> <release_type>

```

An alias can be used to more easily instantiate the script

```bash

alias radio='sh <path_to_script> <path_to_library>'

```

## Parameters

`<library_path>` - path to the library directory (optional)

`<number_of_tracks>` - number of tracks to include in the playlist (optional)

`<genre>` - genre of the release

`<year>` - year of release

`<format>` - type of release (e.g., "lp", "demo")

Trailing parameters can be omitted.

## Flags

`-r, --release <release>` - play an entire release that initially matches a string.

`-p, --playlist <playlist>` - play an existing playlist.

## Examples

Generate a playlist of 100 random songs:

```bash

sh radio.sh 100

```

Generate a playlist of 90s brutal death metal demos:

```bash

sh radio.sh brutal 199. demo

```

Generate a playlist of LPs from any genre and year:

```bash

sh radio.sh % % lp

```

Play all releases initially matching some string:

```bash

sh radio.sh -r "entombed"

```

Play an existing playlist;

```bash

sh radio.sh -p <playlist>

```

## Saving tracks

Pressing the "s" key after playback saves the preceding track to a file called `favorites.txt` in the `<library>` directory.

## Dependencies

`mplayer` is required for playing audio files.

## License

This project is licensed under the `MIT License`. 



