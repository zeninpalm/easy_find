[ ![Codeship Status for zeninpalm/easy_find](https://www.codeship.io/projects/d90d0ce0-fb4e-0131-f607-1228941fa717/status)](https://www.codeship.io/projects/29182)

EasyFind v1.2
=============

EasyFind is a thin wrapper of \*nix find command.
It enables users to specify find command line. The syntax of
EasyFind is quite simple, and you may easily replace current syntax
with your perferred syntax.

Specify find command in STDIN string
_________________

Run *easy_find*, and you may specify intended find command in the STDIN string as follows:
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

```
The script will print generated find command line in the last line.

Specify find command in a .rb file
_____________________

You may save the above contents in a .rb file, say demo.rb.
Then run "*easy_find* demo.rb", and copy&paste generated printed find command line.

API calls
_____________________

```ruby
require 'easy_find'

find_command = EasyFind::Finder.find do
  in_folder { "/usr/bin" }
  where do
    ...
  end
  with_actions do
    ...
  end
end
```

