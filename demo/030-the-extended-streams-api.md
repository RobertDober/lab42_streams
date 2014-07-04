# Lab42::Streams Demo

## The Extended Stream API

###### Merging

Starting from our cannonical `ints` again, we will show how to merge infinite streams together

```ruby
    ints = iterate 0, :succ
    evens = ints.map :*, 2
    odds  = evens.map :succ

    evens.take(5).assert == [0, 2, 4, 6, 8]
    odds.take(5).assert == [1, 3, 5, 7, 9]

    numbas = merge_streams evens, odds
    numbas.take(5).assert == [*0..4]
```

`merge_stream` was **not** concieved as a `Stream` instance method by choice, as all parameters have the same role.


streams of unequal length can be merged together too:

```ruby
    letters = finite_stream %W{a b c}
    digits  = finite_stream 1..4
    
    merge_streams( letters, digits )
      .to_a
      .assert == [ "a", 1, "b", 2, "c", 3, 4 ]
```

and that goes for a mixture of finite and infinite streams too.

```ruby
    
    merge_streams( letters, ints )
      .take( 7 )
      .assert == [ "a", 0, "b", 1, "c", 2, 3 ]
```


###### Scan, a reduce for infinite streams.
