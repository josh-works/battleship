# An excruciatingly-detailed but hopefully comprehensive walkthrough

In the same style as I [did a walk-through](https://github.com/josh-works/futbol) of Turing's Futbol project, I'm doing the same on this Battleship project.

Project home: [https://backend.turing.edu/module1/projects/battleship/requirements](https://backend.turing.edu/module1/projects/battleship/requirements)

I am making this from scratch, and will explain every commit. Hopefully, elements of my process and approach will be fruitful to others. 

For context, I graduated from Turing in 2017, and have been working in Ruby/Rails ever since. I'm not an expert, but I've written a lot of code that's in production in various places, and been paid well for it. 

I'm optimizing for speed, here, because I don't have much time. 

It's 9:35 AM, 2021-10-22, and I'm 3 minutes into this project. I'll keep a bit of a running timeline as I go, because that can be useful. I have a meeting in 22 min, hope to be done with I1 by then.

Current commit: `https://github.com/josh-works/battleship/commits/42d782d`

----------------

## Basic setup

We've got an interaction pattern. At minimum, a ship and a cell. I can see what methods it'll respond to, so I'm going to frame both out (in the library _and_ test files) but leave it blank.

I ♥️ Minitest, so that's what I'll use.

First, I created four new files:

```
.
├── lib
│   ├── cell.rb
│   └── ship.rb
├── readme.md
└── test
    ├── cell_test.rb
    └── ship_test.rb
```

Next, I'll build a test_helper so I don't have to re-reference files.

Outlined a basic test in `ship_test.rb`, added/committed:

Current commit: `https://github.com/josh-works/battleship/commits/a6eca27`

## First ship test(s)

Lets make the test pass. 

here's the current test:

```ruby
require './test/test_helper'

class ShipTest < Minitest::Test
  def setup
    @ship = Ship.new("cruiser", 3)
  end
  
  def test_attributes
    assert_equal "cruiser", @ship.name
    assert_equal 3, @ship.length
    assert_equal 3, @ship.health
    # refute ship.sunk
  end
end
```

Added the basic ship structure:

```ruby
class Ship
  attr_reader :name, :length
  def initialize(name, length)
    @name = name
    @length = length
  end
end
```

## Ship#health

Now I need `Ship#health` to exist. Since length is fixed, but health isn't, I'm setting `@health` in initialization to the same value as `length`, and then I'll `-=` it as time goes on.

```ruby
class Ship
  attr_reader :name, :length, :health
  def initialize(name, length)
    @name = name
    @length = length
    @health = length
  end
end
```
Now `Ship#sunk?` should prob return false as long as `health` is `> 0`:

Here's the test:

```ruby
class ShipTest < Minitest::Test
  def setup
    @ship = Ship.new("cruiser", 3)
  end
  
  def test_attributes
    assert_equal "cruiser", @ship.name
    assert_equal 3, @ship.length
    assert_equal 3, @ship.health
    refute @ship.sunk?
  end
end
```

and the class:

```ruby
class Ship
  attr_reader :name, :length, :health
  def initialize(name, length)
    @name = name
    @length = length
    @health = length
  end
  
  def sunk?
    health == 0  # returns false unless health is 0. Neat huh?
  end
end
```

Current commit: `https://github.com/josh-works/battleship/commits/3dcdbe0`


OK, so the ship is outlined, now we need ways to "interact" with it. 

## `Ship#hit`

The interaction pattern has this:

```ruby
> cruiser.sunk?
#=> false

> cruiser.hit

> cruiser.health
#=> 2

> cruiser.hit

> cruiser.health
#=> 1

> cruiser.sunk?
#=> false

> cruiser.hit

> cruiser.sunk?
#=> true
```
I'm adding this test:

```ruby
def test_ship_can_be_hit_and_sunk
  @ship.hit
  assert_equal 2, @ship.health
  refute @ship.sunk?
  
  @ship.hit
  @ship.hit
  
  assert_equal 0, @ship.health
  assert @ship.sunk?
end
```

Now I need to add the `hit` method:

```ruby
class Ship
  attr_reader :name, :length, :health
  def initialize(name, length)
    @name = name
    @length = length
    @health = length
  end
  
  def sunk?
    health == 0
  end
  
  def hit
    @health -= 1
  end
end
```

And the tests pass. That finishes our ship interaction pattern.

Current commit: https://github.com/josh-works/battleship/commits/908fef9

-----------------

## `Cell` tests

3 minutes left before my meeting... onward!

ok, meeting time, here's my test. I'll make it pass after:

```ruby
require './test/test_helper'

class CellTest < Minitest::Test
  def setup
    @cell = Cell.new("B4")
    @cruiser = Ship.new("Cruiser", 3)
  end
  
  def test_basic_attributes
    assert_equal "B4", @cell.coordinate
    assert_nil @cell.ship
    assert @cell.empty?
  end
  
  def test_place_ship_places_ship
    @cell.place_ship(@cruiser)
    assert_equal @cruiser, @cell.ship
    refute @cell.empty?
  end
end
```

-------------

Meeting's over, lets push a bit farther:

Quickly outlined the `Cell`:

```ruby
class Cell
  attr_reader :coordinate, :ship, :empty
  def initialize(coordinate)
    @coordinate = coordinate
    @ship = nil
    @empty = true
  end
  
  def empty?
    empty
  end
end
```

## `Cell#place_ship(ship)`

Now lets deal with `place_ship`:

```ruby
# test/cell_test.rb
def test_place_ship_places_ship
  @cell.place_ship(@cruiser)
  assert_equal @cruiser, @cell.ship
  refute @cell.empty?
end
```

I'm going to refactor the `empty?` method - taking it out of the initialize method, and instead reading the `@ship` ivar (instance variable), and "doing logic" on that:

```ruby
class Cell
  attr_reader :coordinate, :ship
  def initialize(coordinate)
    @coordinate = coordinate
    @ship = nil
  end
  
  def empty?
    true unless ship # I don't love this, but it gives me what I want.
  end
  
  def place_ship(ship)
    @ship = ship
  end
end
```

All tests pass, I'm at 

https://github.com/josh-works/battleship/commits/66850d5

---------------

## `Cell#fired_upon?`

From iteration 1:

> Additionally, a cell knows when it has been fired upon. When it is fired upon, the cell’s ship should be damaged if it has one:

I'm slimming down the interaction pattern a bit:

```ruby
> cell = Cell.new("B4")
# => #<Cell:0x00007f84f0ad4720...>

> cruiser = Ship.new("Cruiser", 3)
# => #<Ship:0x00007f84f0891238...>

> cell.place_ship(cruiser)

> cell.fired_upon?
# => false

> cell.fire_upon

> cell.ship.health
# => 2

> cell.fired_upon?
# => true
```

Without having any idea how you might implement this, you can still write the tests:

```ruby
def test_cell_can_be_fired_upon_and_know_about_it
  @cell.place_ship(@cruiser)
  
  refute @cell.fired_upon?
  
  @cell.fire_upon
  
  assert @cell.fired_upon?
  assert_equal 2, @cruiser.health
end
```

Now, we are adding two methods to the `Cell` class, so lets outline those methods in the class, so when we run the tests we don't get `MethodNotFound`:

```ruby
# lib/cell.rb

class Cell
  attr_reader :coordinate, :ship
  def initialize(coordinate)
    @coordinate = coordinate
    @ship = nil
  end
  
  def empty?
    true unless ship
  end
  
  def place_ship(ship)
    @ship = ship
  end
  
  def fired_upon?
    
  end
  
  def fire_upon
  end
end
```

Now we're just getting `nil` when we expect other things from the tests. 

Did you do all this yourself, by the way? Are you running the tests in your editor regularly? I expect you to do so, and be "following along" with me, by reproducing everything in your own editor.

Now, I want to be able to call something very simple in `fired_upon?`. Like `ship.any_damage?`

Obviously I could do logic on the ship from the `Cell` class, like:

```ruby
# lib/cell.rb
def fired_upon?
  true if ship.health < ship.length
end
```

But I'd rather do:

```ruby
def fired_upon?
  ship.damaged?
end
```

which requires us to add a `damaged` method (and test) to our ship class...

Nevermind, I'm going to make `fired_upon` read from an instance variable. This is a `cell`, a specific coordinate, it doesn't need to know if the ship has been hit in other spots.

Here's what I've got now:

```ruby
class Cell
  attr_reader :coordinate, :ship, :fired_upon
  def initialize(coordinate)
    @coordinate = coordinate
    @ship = nil
    @fired_upon = false
  end
  
  def empty?
    true unless ship
  end
  
  def place_ship(ship)
    @ship = ship
  end
  
  def fired_upon?
    fired_upon
  end
  
  def fire_upon
    @fired_upon = true # toggles the value in the cell
    ship.hit           # causes the ship to record some damage
  end
end
```

All looks good, tests pass. 

https://github.com/josh-works/battleship/commits/e930918

## Adding a `Rakefile` to make running tests easy

Now that I have two test files, I'm going to add a Rake file that allows me to run `rake test` and run tests against each file in the `test` directory:

I use this task regularly, so I copied-and-pasted from another project where I use the Rake task. There's a StackOverflow answer to `how to run all tests via rake` somewhere. 

Now I can do `rake` or `rake test` in the terminal, and all tests are run:

https://github.com/josh-works/battleship/commits/5c147d7

---------------------

## `Cell#render`

Lets build this `Cell#render` method...

> Finally, a Cell will have a method called render which returns a String representation of the Cell for when we need to print the board. A cell can potentially be rendered as:
> 
>     ”.” if the cell has not been fired upon.
>     “M” if the cell has been fired upon and it does not contain a ship (the shot was a miss).
>     “H” if the cell has been fired upon and it contains a ship (the shot was a hit).
>     “X” if the cell has been fired upon and its ship has been sunk.


so, our test will have things like:

```ruby
# cell_test.rb

def test_render_return_values
  
  # . if the cell has not been fired upon.
  # M if the cell has been fired upon and it does not contain a ship (the shot was a miss).
  # H if the cell has been fired upon and it contains a ship (the shot was a hit).
  # X if the cell has been fired upon and its ship has been sunk.

end
```

Now I'm going to "upgrade" each of these into some assertions, as far as I can:

```ruby
def test_render_return_values
  
  # . if the cell has not been fired upon.
  assert_equal ".", @cell.render
  # M if the cell has been fired upon and it does not contain a ship (the shot was a miss).
  assert_equal "M", @cell.render
  
  # H if the cell has been fired upon and it contains a ship (the shot was a hit).
  assert_equal "H", @cell.render
  
  # X if the cell has been fired upon and its ship has been sunk.
  assert_equal "X", @cell.render
end
```

Obviously this won't pass. Any cell by default won't be fired upon, so the first one should be easy to do. I then created an empty cell, and now the second `render` case should be passing:

```ruby
def test_render_return_values
  # . if the cell has not been fired upon.
  assert_equal ".", @cell.render
  
  empty_cell = Cell.new
  empty_cell.fire_upon
  # M if the cell has been fired upon and it does not contain a ship (the shot was a miss).
  assert empty_cell.empty?
  assert_equal "M", empty_cell.render
  
  # H if the cell has been fired upon and it contains a ship (the shot was a hit).
  assert_equal "H", @cell.render
  
  # X if the cell has been fired upon and its ship has been sunk.
  assert_equal "X", @cell.render
end
```

I had to slighly modify the test, to pass in coordinates to `Cell.new`, and I had to update the `fire_upon` method to only call `ship.hit` if there is, in fact, a ship:

```ruby
def fire_upon
  @fired_upon = true
  ship.hit if ship
end

def render
  return "." if !fired_upon?
end
```

Now the first portion of the test passes, and it's failing on the `assert_equal "M"`... line.

Progress!

Let's add a line with some aspirational code to the `render` method:

```ruby
def render
  return "." if !fired_upon?
  return "M" if fired_upon_empty_cell?
end
```

That's a method I didn't write, this `fired_upon_empty_cell?` thing. Here's the other way to write it:

```ruby
def render
  return "." if !fired_upon?
  return "M" if (fired_upon? && empty?)
end
```

But this is getting complicated, so lets do this:

```ruby
def render
  return "." if !fired_upon?
  return "M" if fired_upon_and_empty?
end

def fired_upon_and_empty?
  fired_upon? && empty?
end
```

We could write tests for these new methods, and maybe you should, but I'm not going to. I'm going to refactor the first line of `render` to be explicit:

```ruby
def render
  return "." if cell_has_not_been_fired_upon?
  return "M" if fired_upon_and_empty?
end

def cell_has_not_been_fired_upon?
  !fired_upon?
end

def fired_upon_and_empty?
  fired_upon? && empty?
end
```

You should be able to see how this is making things slightly clearer...

Now, in the test, we need to:

1. Add a ship to the cell
2. Fire upon that ship
3. Make some assertions about the results

Here's our test:

```ruby
def test_render_return_values
  # . if the cell has not been fired upon.
  assert_equal ".", @cell.render
  
  empty_cell = Cell.new("B5")
  empty_cell.fire_upon
  # M if the cell has been fired upon and it does not contain a ship (the shot was a miss).
  assert empty_cell.empty?
  assert_equal "M", empty_cell.render
  
  # H if the cell has been fired upon and it contains a ship (the shot was a hit).
  @cell.place_ship(@cruiser)     # place the ship
  @cell.fire_upon                # fire upon placed ship
  
  assert_equal "H", @cell.render # assert that ship shows it's been hit
  
  # X if the cell has been fired upon and its ship has been sunk.
  assert_equal "X", @cell.render
end
```

And here's the modified code:

```ruby
def render
  return "." if cell_has_not_been_fired_upon?
  return "M" if fired_upon_and_empty?
  return "H" if fired_upon_and_contains_ship?
end

def fired_upon_and_contains_ship?
  fired_upon? && ship
end
```

Ah, and for the last one, I need to bump the order - with return statements, as soon as a "matching" clause is arrived upon, the method exists. So, I need for the method to check if the ship is sunk (and exit if it is) before it checks to see if the cell has been fired upon and contains a ship.

Compare:

```ruby
def render
  return "." if cell_has_not_been_fired_upon?
  return "M" if fired_upon_and_empty?
  return "H" if fired_upon_and_contains_ship?
  return "X" if ship_has_been_sunk?
end
```

vs:

```ruby
def render
  return "." if cell_has_not_been_fired_upon?
  return "M" if fired_upon_and_empty?
  return "X" if ship_has_been_sunk?
  return "H" if fired_upon_and_contains_ship?
end
```

The 2nd `render` method is better than the first, and makes the test pass. That test is gnarly, though. I'll commit it, then refactor it into something clearer. Here's the pre-refactor version:

https://github.com/josh-works/battleship/commits/705a27d

## Refactoring the `Cell#render` test and method

Now I'm gonna refactor into more clearly labeled test cases. I did slight modifications, mostly just added `def test_` blocks within the prior test. After refactoring the test, I decided to re-name two of the methods inside of `render`:


https://github.com/josh-works/battleship/commits/71efefe

-------------

Phew, almost done with iteration 1, I've been at this for... 35 min so far? maybe? I love these projects. It's fun to sling so much code so quickly. Normally I spend all day to make like a 1-line change.

## `debug_mode` in `Cell#render`

Lets add the last piece of i1:

> Additionally, we will include an optional boolean argument to indicate if we want to reveal a ship in the cell even if it has not been fired upon. This should render a cell that has not been fired upon and contains a ship as an “S”. This will be useful for showing the user where they placed their ships and for debugging.


Here's my test:

```ruby
def test_render_in_debug_mode_reveals_ship_location
  @cell.place_ship(@cruiser)
  empty_cell = Cell.new("C2")
  
  assert_equal ".", @cell.render
  
  assert_equal "S", @cell.render(true)
  assert_equal ".", empty_cell.render(true)
end
```

Let's make it pass!

First, we'll update `render` to take an argument, we'll call it `debug_mode`, and default it to `false`:

```ruby
def render(debug_mode=false)
  .
  .
  .

```

Now we'll do something if `debug_mode` is true...



```ruby
def render(debug_mode=false)
  return "S" if debug_mode && ship && cell_has_not_been_fired_upon?
  return "." if cell_has_not_been_fired_upon?
  return "M" if shot_was_a_miss?
  return "X" if ship_has_been_sunk?
  return "H" if shot_was_a_hit?
end
```

Callin' it here. Done with iteration 1.


https://github.com/josh-works/battleship/commits/16e82c9





