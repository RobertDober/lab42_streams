# Lab42::Streams Demo

## The Stream API

### Minimal API

There are only five public methods to implement streams, everything else is just (important)
convenience code, building on the minimal API.

#### Constructing Streams Method

The only building block for a stream is the `Kernel#cons_stream` method.

It takes the stream's head as positional parameter and the tail as a block.

```ruby
    all_ones = cons_stream(1){ all_ones }
    all_ones.assert.kind_of? Stream
```

This is an infinite stream of ones, which can now be accessed, with...


#### Querying Streams Methods

We have now the `Stream#head` and `Stream#tail method` to query streams

```ruby
    all_ones.head.assert == 1
    all_ones.tail.tail.tail.head.assert == 1
```

#### Empty Stream Methods

Had it not been for finite streams the above three methods would have sufficed. However, as mentioned before,
finite streams need a special end marker. The first idea might to return nil as a tail, but the tail of a stream
needs to yield a stream when forced. (By design)

Thus we opted to implement the `empty stream` concept as in [the canonical implementation](http://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-001-structure-and-interpretation-of-computer-programs-spring-2005/video-lectures/6a-streams-part-1/)

`Kernel#empty_stream` yields a singleton object, which is also exposed as `EmptyStream` and behaves as follows:

```ruby
    empty_stream.assert.kind_of? Lab42::Stream::Empty
    empty_stream.assert == EmptyStream
```




