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

Next, I'll build a test_helper so I don't have to re-reference files:

