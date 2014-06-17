EasyFind
=============

EasyFind is a thin wrapper of \*nix find command.
It enables users to specify find command line. The syntax of
EasyFind is quite simple, and you may easily replace current syntax
with your perferred syntax.

Usage
_____

1. Specify find command in STDIN string
You may specify intended find command in the STDIN string as follows:
```ruby
EasyFind::Finder.find do
  in_folder { [".", "~", "/usr/bin"] }
  where do
    type "f"
    size :greater_than, 1000
    grouping do
      atime :greater_than, 7
      or_else
      mtime :less_than, 10
    end
  end
  with_actions { print }
end

^D

The script will print generated find command line in the last line.

