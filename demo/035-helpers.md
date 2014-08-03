# Lab42::Streams Demo

## Helpers

### Segmenting Streams

#### segment

Segments a `stream` into segments of subsequent values:


##### A simple, finite example

A finite stream segmented:

```ruby
    sentence = %w{my dear, I said, I know my stuff}.to_stream
    my_oh_my = sentence.segment :==, "my"

    my_oh_my.assert.kind_of? Stream
    my_oh_my.map(:to_a).to_a.assert == [ %w{my dear, I said, I know}, %w{my stuff} ]
```

##### A simple, infinite example

An infinite stream segmented into finite segments

```ruby
    # ints   = iterate 0, :succ
    threes = ints.segment{ |n| n % 3 == 1 }

    threes.take( 5 ).map( &:to_a ).assert = [ [0], [1, 2, 3], [4, 5, 6], [7,8,9,], [10, 11, 12]]
```

##### Infinite segments

The following code demontsrates, what I call the _trap of laziness_, if we segment, say the ints into ints smaller than 42 and
the rest as follows:

```ruby

    segments =
      ints.segment :==, 42

    segments.head.to_a.assert == [*0..41]
    segments.tail.head.drop(1000).take.assert == [1042]
```

Now what would `segments.tail.tail` be?


I'd call it _undefined_, howver, trying to calculate it is not such a good idea, (it simply loops).
Well why is that?

Actually if we look at it from a definition point of view is surely is empty, right? Not so right, we
are confusing _our_ definition with the one we gave to Ruby ;).

In _stream_ terms `segments.tail.tail` is defined as the tail of the second segment which is the segment of all
ints following 42 following the next 42, which will never arrive. But this **will never arrive** is not part of
the definition at all and Ruby, quite correctly is just looking for that 42 > 42 in the infnite stream of ints.

It might as well not find it ;(.


## Covnenience Methods

The `Stream` API is so powerful that many methods of the `Enumerable` API are trivial to implement.

However readability and expectations might not be served best with the following code

```ruby
    # An implementation of Enumerable#with_index

    some_stream = const_stream 1
    some_stream.zip( iterate 0, :succ ).map(&:entries).take( 5 ).assert == [ [1, 0], [1, 1], [1, 2], [1, 3], [1, 4] ]
```

And for those, who find it to cumbersome to map explicitly to array elements, there is `zip_as_ary`

```ruby
    some_stream.zip_as_ary( iterate 10, :succ).take( 3 ).assert == [ [1, 10], [1, 11], [1, 12] ]
```

But the `with_index` method does just that, more or less.

```ruby
    some_stream.with_index.take(2).assert == [[1,0], [1,1]]
    some_stream.with_index( from: 10 ).take( 2 ).assert == [[1,10], [1,11]]
```

