# Cmd-utils

Cmd-utils is a set of programs for making certain things more convenient from the windows command line. There are a lot of little gaps that the windows CLI has compared to bash, things like not having a great way to counte lines, or examine memory usage, or perform commands over file globs.

## Why this instead of powershell?

Use Powershell Core if you can. I've been convinced to use it more than stuff like this now.

~~If powershell works for you, great! For me, it tends to fall down a little bit in interactive use, or is a bit clunky at answering the questions I'm looking to answer. Hence, these utils.~~

## Installation

First, you'll want to [install Janet](https://janet-lang.org/docs/index.html#Installation). Then clone this repo, and run `jpm build`. This will create a file called `size.exe` in the `build` folder. To install `size`, put `size.exe` on your `%PATH%`.

# The Utils

## Implemented

### web-dir

`web-dir` starts a static file server on port localhost:8000, reports Last-Modified, and sets CORS headers to allow SharedArrayBuffers to work in WASM code.

### size

`size` is a small program for counting words, lines and bytes in a windows command prompt. It can be used on linux or osx, but is likely not needed there, due to the presence of `wc`.

### env-explode

`env-explode` prints out delimited environment variables, one element per line.

## Unimplemented

## run

`run` can be used to customize the environment a given command runs under. `NAME=VALUE` pairs set up the environment, the `/CD` or `-cd` flag changes to a different directory, and the `-c` or `-cmd` flag sets the command to be run. `/SH` has run use shell-execute, but it does not by default.

### Usage

## each

`each` is not unlike the unix `find` (as opposed to the windows `find`, which is more like the unix `grep`). It can iterate files, directories, PIDs, services, or numeric ranges.

### Usage

```
each -g "*.js" -c "type %1"
```

## mem

`mem` scans over the output of `tasklist.exe`, tallying up memory totals. It can give you the output by exectuable name, by pid, or by session id. It's not a fancy program, but has helped me diagnose where my memory usage has been going.

### Usage

```
mem by-name -MB
```

`-KB`, `-MB`, and `-GB` will report memory usage in kilobytes, megabytes and gigabytes respectively. 

### Usage

`type README.md | size` should output something like:

```
Stdin was 19 lines, 112 words, and 705 bytes
``` 

`-KB`, `-MB`, and `-GB` will report sizes in kilobytes, megabytes and gigabytes respectively. 

See `-help` for more info.
