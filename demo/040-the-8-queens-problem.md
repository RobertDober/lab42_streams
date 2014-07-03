# Lab42::Streams Demo

## A Typical Application: N-Queens

Tree expoloration needing backtracking can very often be expressed much more elegantley with `Streams`.

This follows almost directly from the lazy property of streams. While in a classical, eager, backtracking
algorithm, we expand a tree for solutions and have to backtrack whenever we end up in a dead end.

If however we can model the tree as a `Stream` (of `Streams` that is) we first define the expansion, and then simply$
filter. 

Only eventually, when we look for the solution(s), we will expand _nodes_ and the filtering will take care of dead end
elimination without backtracking.

### Solving the N-Queens problem

The [N-Queens problem](https://en.wikipedia.org/wiki/Eight_queens_puzzle) consists of putting N queens on a NxN chessboard so that no Queen menaces any other queen.

Here is a very elegant example as taken from the cannonical [Structure and Interpretation of Computer Prorams](http://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-001-structure-and-interpretation-of-computer-programs-spring-2005/)

```ruby
    # We represent the board as an Array of rows, representing the column position of the queen in the corresponding row. 
    # The following method will tell us if it is a legal solution (everything else will be much easier!).
    class ::Array
      def legal?
        each_with_index.all?{ |e,i| !drop(i.succ).each_with_index.any?{ |f,j| e==f || (f-e).abs == (j+1) }}
      end
    end

    # The expand method will take a position and will expand it into a finite stream of legal positions with one
    # row added

    def expand pos, size
      finite_stream(0...size)
        .map{ |i|
          pos + [i]
        }
        .filter :legal?
    end

    # fill will recursively fill the board (meaning a tree, or better even, a stream of streams of legal positions)
    # up to size, starting with [[]] (a stream of an empty stream)
    def fill k, size
      return finite_stream [[]] if k.zero?
      fill( k-1, size ).flatmap{ |pos| expand( pos, size ) }
    end

    def queens size
      fill size, size
    end

```

And now we can take advantage of that to get the first solution of the classic 8-queens problem

```ruby
    queens( 8 ).head.assert.assert == [0, 4, 7, 5, 2, 6, 1, 3]
```


