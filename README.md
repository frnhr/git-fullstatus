# Git-fullstatus 

A Bash script that shows "unmodified" files along with modified ones from `git status --porcelain`.
This is achieved by combining `status --porcelain` and `ls-files` commands.

## Installation

Copy `git-fullstatus` to somewhere in your `PATH`.

## Usage

In a git repository:

    $ git-fullstatus
     M some/file
    D  another/file
     D more/files/blahblah
    A  this/is/an/added/file/i/think
       an/unchanged_file
       another/unchanged_file
    $ _

## Output format

Output uses the same format as `git status --porcelain`. Unmodified files are listed with `  ` *(double space)* as `XY`. See git help status for details.

## Testing

[Roundup][1] is needed to run tests.

Simply `cd` to the directory containing `git-fullstatus-test.sh` and run

    $ roundup

## Caveats

 * Not really working with non-ascii characters in file names.
 * Not thoroughly tested with respect to different possible Git statuses, mainly when files are renamed. So no guarantees.


## TODO

 * support different command line options and formats (non-porcelain, "--short" and "--long" mode, "--ignored", etc.)
 
 
[1]: 	https://github.com/bmizerany/roundup/blob/master/INSTALLING#files
