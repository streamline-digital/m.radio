# m.radio

## Description

The `radio.sh` script generates and plays a playlist of audio tracks matching on genre, year, and release format. 

It is intended for use only with a specifically structured library of audio files and may not be widely useful.

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

    <library_path>: Path to the library directory. (Optional)
    <number_of_tracks>: Number of tracks to include in the playlist. (Optional)
    <genre>: Genre of the tracks.
    <year>: Year of release.
    <release_type>: Type of release (e.g., "lp", "demo").

Trailing parameters can be omitted.

## Flags

    -r, --release <release>: Play releases in order by passing a string that matches the initial part of a release directory.
    -p, --playlist <playlist>: Play an existing playlist.

## Examples

Generate a playlist of 100 random songs:

```bash

sh radio.sh 100

```

Generate a playlist of 90s brutal death metal demos:

```bash

sh radio.sh brutal 19.. demo

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

Pressing the "s" key after playback saves the preceding track to a file called `favorites.txt` in the <library> directory.

## Dependencies

    mplayer: Required for playing audio files.

## License

This script is licensed under the MIT License. Feel free to modify and distribute it according to the terms of the license.






