# Lab42::Streams Demo

## Basic Stream Tutorial

Streams are quite an ancient concept of delayed behavior, a promise.

However, the promise is just a part of the `Stream` concept, a `Stream` is
a list abstraction (1) with an eager `head` and a `lazy` tail, making it not 
only possible but default to reason with infinite sized collections and
to apply transformations consequently without a performance loss.

Here are two demonstrations of that concept:

### Infinite Streams

```ruby
  def integers_from n=0
    cons_stream n do
      integers_from n.succ
    end
  end 

  integers_from(10).drop(32).head.assert == 42
```

There are several things to remember here:

* The tail of a stream is *always* provided as block or lambda, the only way in ruby to
implement a normal order parameter.

* The result of the tail (we say when the delay or promise the tail defines is forced or realised)
must be a `Stream`. This has to be automated into your reasoning about `Streams` lest you will
have difficulties to come up with stream based solutions.

* When the promise of the tail is forced the stack frame of the `cons_stream` call is not active
any more, there will be no stack overflow.


### Transformation Chain

```ruby
    great_fizz_buzz = integers_from(100_000).map(:*, 3).filter{ |e| (e%5).zero? }
    great_fizz_buzz.take(4).assert == [300000, 300015, 300030, 300045]
```

There is absolutely no performance penalty here, when we eventually realize the stream with `take`, and only
then, we will execute the transformations.

(1) Some might argue that it is a `cons-cell` abstraction, and they would not
get any argument from me.

