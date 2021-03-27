# size

`size` is a small program for counting words, lines and bytes in a windows command prompt. It can be used on linux or osx, but is likely not needed there, due to the presence of `wc`.

## Installation

First, you'll want to [install Janet](https://janet-lang.org/docs/index.html#Installation). Then clone this repo, and run `jpm build`. This will create a file called `size.exe` in the `build` folder. To install `size`, put `size.exe` on your `%PATH%`.

## Usage

`type README.md | size` should output something like:

```
Stdin was 19 lines, 112 words, and 705 bytes
``` 

`-KB`, `-MB`, and `-GB` will report sizes in kilobytes, megabytes and gigabytes respectively. 

See `-help` for more info.
