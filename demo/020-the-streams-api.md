# Lab42::Streams Demo

## The Stream API

### Minimal API

There are only gour public methods to implement streams, everything else is just (important)
convenience code, building on the minimal API.

#### Constructing Streams Method

The only building block for a (non-empty) stream is the `Kernel#cons_stream` method.

It takes the stream's head as positional parameter and the tail as a block.

```ruby
    all_ones = cons_stream(1){ all_ones }
    all_ones.assert.kind_of? Stream
```

This is an infinite stream of ones, which can now be accessed, with...


#### Querying Streams Methods

We have the `Stream#head` and `Stream#tail method` to query (non-empty) streams

```ruby
    all_ones.head.assert == 1
    all_ones.tail.tail.tail.head.assert == 1
```

#### Empty Stream Method

Had it not been for finite streams the above three methods would have sufficed. However, as mentioned before,
finite streams need a special end marker. The first idea might to return nil as a tail, but the tail of a stream
needs to yield a stream when forced.

Thus we opted to implement the `empty stream` concept as in [the canonical implementation](http://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-001-structure-and-interpretation-of-computer-programs-spring-2005/video-lectures/6a-streams-part-1/)

`Kernel#empty_stream` yields a singleton object, which is also exposed as `EmptyStream` and behaves as follows:

```ruby
    empty_stream.assert.kind_of? Lab42::Stream::Empty
    empty_stream.assert == EmptyStream
```

Ruby offers a very convenient way to loop over Enumerables, by implicitly rescuing from the `StopIteration` exception.

We decided therefore to raise such this exception in case `head` or `tail` of an `EmptyStream` are invoked. This allows us
to do the following:

```ruby
    s = cons_stream(1){
          cons_stream(2){ empty_stream }}

    x = 0
    loop do
      x += s.head
      s = s.tail
    end
    x.assert == 3
```

### A first convenience method

`#empty?`

We could simply compare a stream object with the empty stream, but the `empty?` method is convenient, especially for
higher order streams.

```ruby
    s = cons_stream(nil){empty_stream}
    s.refute.empty?
    empty_stream.assert.empty?

    ho_stream = cons_stream( s ){ cons_stream( empty_stream ){ empty_stream } }
    filtered  = ho_stream.reject(:empty?)

    filtered.tail.assert.empty?
    filtered.head.assert == s
```

Although we used one stream API method not mentioned yet, `reject` these most basic examples make
it very clear that we need a much richer API in order to express algorithms with streams in a readable
and potent way...

### Convenience API

#### finite_stream Methods

The above code would already be much simple if we could avoid the cascades of blocks we do not need
as we provide already existing objects. This can be done by boxing these objects into an `Enumerable` instance
and passing it into the `finite_stream` factory.

```ruby
    s = finite_stream [nil, 42]

    s.head.assert.nil?
    s.tail.head.assert == 42
    s.tail.tail.assert.empty?
```

Alternatively we can use `to_a`, its alias `entries` or the recursive `force_all`  method to get an array back out
of the **finite** stream.


```ruby
    s.to_a.assert == [nil, 42]
    s.entries.assert == [nil, 42]
    s.force_all.assert == [nil, 42]
```


And let us not forget the most finite of all finite streams, the empty one:

```ruby
    empty_stream.to_a.assert == []
    empty_stream.entries.assert == []
    empty_stream.force_all.assert == []
```


##### force_all

`force_all` descends into streams if elements are streams, meaning that the following to streams have the same return
value for an invocation of `force_all`

```ruby
    s1 = finite_stream [ [1,2,3,4] ]
    s2 = finite_stream [ s1 ]
    s1.force_all.assert == [ [1,2,3,4 ] ]
    s2.force_all.assert == [[ [1,2,3,4 ] ]]
```

`force_all` also detects recursions and avoids to descend into them

```ruby
    s1 = finite_stream [ 1, s1 ]

    s1.force_all.assert == [ 1, [[1,2,3,4]] ]
```

##### Inject and Reduce

As `inject` and `reduce` force all elements they too, are limited to finite streams, unless of course you have
plenty of time (and potentially plenty of space).

```ruby
    digits = finite_stream 0..9
    sum    = digits.reduce :+
    sum.assert == 45

    augmented = digits.inject 10, :+
    augmented.assert == 55
```

Of course you can provide a block or a lambda

```ruby
    # A lambda
    digits.reduce( Fixnum.fm.+ ).assert == 45
    # A block
    digits.inject(10){|a, e| a+e }.assert == 55
```

###### Edge Cases

The behavior of the edge cases for zero and one element streams are inispired by
the behavior of Ruby's Enumerable.

```ruby
    [].reduce{|a,e| some_nonexisting_method }.assert.nil?
    # and thus, as empty_stream carries the role of nil.
    empty_stream.reduce(:some_nonexisting_method).assert.empty?

    [].inject(42){}.assert == 42
    empty_stream.inject( 42, :non_existing_method ).assert == 42
```

#### General Stream Methods

The following methods can savely be invoked on inifinite streams too.

##### The Classic Enumerable API

In order to be able to better demonstrate the effect of the application on inifinite streams
we start with the `take*` methods.

The non negative integers will give us a perfect example of an infinite stream, with which
about everybody is quite familiar.

```ruby
    ints = iterate 0, :succ

    ints.take.assert == [0]
    ints.take(5).assert == [*0..4]
    ints.take_while{ |a| a < 2 }.assert == [0, 1]
   
    ints.take_until( :>, 9 ).assert == [*0..9]
```


It is important to remember that streams are immutable, and thus of corse the following still holds

```ruby
    ints.drop(5).head.assert == 5
    ints.head.assert.zero?
```


