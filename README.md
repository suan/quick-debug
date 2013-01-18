Quick - debug!
============
When debugging in Ruby, print statements are still often the best tool for the job. But how many times have you found yourself typing stuff like this over and over?

```ruby
def main
  puts "========= in main"
  movie_dirs.each do |movie_dir|
    Find.find(movie_dir) do |fn|
      if fn.is_movie?
        parent_dir = File.dirname(fn)
        movie = nil
        if movie_dirs.include? parent_dir or parent_dir.has_another_movie(fn)
          puts "========= in if movie_dirs..."
          movie = get_movie fn
          puts "========= movie: #{movie.inspect}"
        else
          movie = get_movie(fn, true)
        end
    .......
```

What if you could just do this instead?

```ruby
def main
  D.bg
  movie_dirs.each do |movie_dir|
    Find.find(movie_dir) do |fn|
      if fn.is_movie?
        parent_dir = File.dirname(fn)
        movie = nil
        if movie_dirs.include? parent_dir or parent_dir.has_another_movie(fn)
          movie = get_movie fn
          D.bg{'movie'}
        else
          movie = get_movie(fn, true)
        end
    .......
```

Now you can.

Installation
------------
In your Gemfile, add:

```
gem 'quick-debug'
```
_or_ run this, then require the gem as such:

```
$ gem install quick-debug
```
```ruby
require 'quick-debug'
```
For especially legacy/hostile environments, or if you want to use this _really_ quickly, you can directly require the `quick-debug.rb` file in your code - it has no dependencies. If you do this often, a symlink could come in really useful. For example:

```
$ sudo ln -s /Library/Ruby/Gems/1.8/gems/quick-debug-0.0.1/lib/quick-debug.rb /quick-debug.rb
```

Then, from within your code:

```ruby
require '/quick-debug'
def main
  D.bg
  movie_dirs.each do |movie_dir|
  ....
```

Usage
-----
```
D.bg{'@somevar'}
```
Prints `[<caller filename, method, and line number>] @somevar ~> <contents of @somevar.inspect>` to STDOUT. Any object can be passed in, but it must be surrounded by quotes or be made a symbol. If the block is omitted, only the caller method and line number will be printed.

```
D.lg{'@somevar'}
```
Same as above, but prints to `/tmp/quick-debug.txt` instead. A short timestamp is also printed at the start of each line. To change the output filepath, do

```
D.logpath = '</some/path/log.txt>'
```

```
D.str{'@somevar'}
```
The above methods just return the deubg output as a string, rather than printing them anywhere. This can be very useful if you need to use your own logging framework, for example: `logger.debug D.str{'@somevar'}`.

```
D.disable :bg
```
prevents all `D.bg` statements from printing anything. You can also pass in `:lg` or `:all` to disable `D.lg` statements or just everything respectively. You can use
```
D.enable
```
to re-enable them. It accepts the same options.

```
D.bg(:force){'@somevar'}
D.lg(:force){'@somevar'}
```
The debug methods accept a `:force` argument, which will cause those calls to run even though that output location been disabled.

### Happy Debugging!! ###
