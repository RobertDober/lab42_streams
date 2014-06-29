# Lab42::Streams Demo

## Basic Stream Tutorial

Streams are lazy lists, or for the purists, lazy cons cells (well the tail/cdr is lazy, the head/car is not).

Here are two demonstrations of that concept:

### Infinite Streams

```ruby
    require 'pry'
    def fibs a=0, b=1
      cons_stream a do
        fibs b, a+b
      end
    end 

    fibs.drop(1000).head.assert == 43466557686937456435688527675040625802564660517371780402481729089536555417949051890403879840079255169295922593080322634775209689623239873322471161642996440906533187938298969649928516003704476137795166849228875
```

There are several things to remember here:

* The tail of a stream is *always* provided as block or lambda, the only way in ruby to
implement a normal order parameter.

* The result of the tail (that is when the delay or promise the tail defines is forced or realised)
must be a `Stream`. This has to be automated into your reasoning about `Streams` lest you will
have difficulties to come up with stream based solutions.

* When the promise of the tail is forced the stack frame of the `cons_stream` call is not active
any more, there will be no stack overflow.


### Transformation Chain

One major advantage of streams (and lazy evaluation in general) is that transformations can be composed without any performance penality.

While for example the following code would be terribly inefficent

```ruby
    elements = { 2 => "two", 4 => "four" }
    list = 1..2 # but imagine a very large value of 2
    list.map{ |x| x * 2 }.map{ |x| elements[x] }.map(&:reverse)
```

the following stream based code is not.

```ruby
  
     translation = { [true,true] => "fizzbuzz", [true, false] => "fizz", [false, true] => "buzz" }
     integers    = Stream.iterate 0, :succ
     fizzbuzz    = integers
        .reject{ |x| (x%100).zero? }
        .map{ |i| [(i%3).zero?,(i%5).zero?,i] }
        .map{ |f,b,i| translation.fetch([f,b],i) }
```

The reason for this is that, up to now, no single computation has been done, but _promises_ for doing so
have been registered. Only when we eventually force values these computations will be executed and then
it will make little difference if we execute one complex computation or five simple ones.


A different way to look at this is in the following application

```ruby
    fizzbuzz
      .drop( 1000 )
      .take( 15 ).assert == ["fizz", 1012, 1013, "fizz", "buzz", 1016, "fizz", 1018, 1019, "fizzbuzz", 1021, 1022, "fizz", 1024, "buzz"]
```




There is absolutely no performance penalty here, when we eventually realize the stream with `take`, and only
then, we will execute the transformations.

(1) Some might argue that it is a `cons-cell` abstraction, and they would not
get any argument from me.


### Memoization

It is of the uttermost importance to assure that the promise is only realized once, this is done via memoization
and allows the following defintion of the fibonacci numbers to have `O(n)` runtime.

```ruby

    def add_streams s1, s2
      return empty_stream if s1.empty? || s2.empty?
      cons_stream s1.head + s2.head do
        add_streams s1.tail, s2.tail
      end
    end
    fibs1 = cons_stream(0){
      cons_stream(1){
        # Without memoization we would evaluate the fibs call tree twice
        add_streams fibs1, fibs1.tail
      }
    }

    fibs1.drop(1000).head.assert == 43466557686937456435688527675040625802564660517371780402481729089536555417949051890403879840079255169295922593080322634775209689623239873322471161642996440906533187938298969649928516003704476137795166849228875
```


## Finite Streams

Finite Streams are implemented the same way LISP imlements lists, by providing an _End_Marker_. What is `nil` in LISP
is `empty_stream` in Ruby. As a matter of fact the `empty_stream` method returns a singleton called `Lab42::Stream::Empty` which
is also accessible via `EmptyStream` if you required the lib with `require 'lab42/stream/auto_import'` as has been done here.


The following is the