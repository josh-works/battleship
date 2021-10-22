# An excruciatingly detailed but hopefully comprehensive walkthrough

In the same style as I [did a walk-through](https://github.com/josh-works/futbol) of Turing's Futbol project, I'm doing the same on this Battleship project.

Project home: [https://backend.turing.edu/module1/projects/battleship/requirements](https://backend.turing.edu/module1/projects/battleship/requirements)

I am making this from scratch, and will explain every commit. Hopefully, elements of my process and approach will be fruitful to others. 

For context, I graduated from Turing in 2017, and have been working in Ruby/Rails ever since. I'm not an expert, but I've written a lot of code that's in production in various places, and been paid well for it. 

I'm optimizing for speed, here, because I don't have much time. 

It's 9:35 AM, 2021-10-22, and I'm 3 minutes into this project. I'll keep a bit of a running timeline as I go, because that can be useful. I have a meeting in 22 min, hope to be done with I1 by then.

Current commit: `https://github.com/josh-works/battleship/commits/42d782d`

----------------

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


