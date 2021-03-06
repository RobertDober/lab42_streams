[![Build Status](https://travis-ci.org/RobertDober/lab42_streams.svg?branch=master)](https://travis-ci.org/RobertDober/lab42_streams)
[![Code Climate](https://codeclimate.com/github/RobertDober/lab42_streams/badges/gpa.svg)](https://codeclimate.com/github/RobertDober/lab42_streams)
[![Issue Count](https://codeclimate.com/github/RobertDober/lab42_streams/badges/issue_count.svg)](https://codeclimate.com/github/RobertDober/lab42_streams)
[![Test Coverage](https://codeclimate.com/github/RobertDober/lab42_streams/badges/coverage.svg)](https://codeclimate.com/github/RobertDober/lab42_streams)
[![Gem Version](https://badge.fury.io/rb/lab42_streams.svg)](http://badge.fury.io/rb/lab42_streams)

# lab42\_streams

## Bringing Streams to Ruby

An excellent introduction into `Streams` can be found [here](http://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-001-structure-and-interpretation-of-computer-programs-spring-2005/video-lectures/6a-streams-part-1/)

## Basic Stream Tutorial

Streams are lazy, immutable lists, or for the purists, lazy cons cells (well the tail/cdr is lazy, the head/car is not).

A first example

### Infinite Streams

Given the following definition

```ruby :include
    def fibs a=0, b=1
      cons_stream a do
        fibs b, a+b
      end
    end
```

The following spec will be satisfied

```ruby :example
    expect(fibs.drop(1000).head).
      to eq(43466557686937456435688527675040625802564660517371780402481729089536555417949051890403879840079255169295922593080322634775209689623239873322471161642996440906533187938298969649928516003704476137795166849228875)
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

And as we operate on **infinite** streams it becomes obvious that the implementation must delay up to the end.

### Memoization

The fourth point to know about `Streams` is that:

* All promises are **memoized**.



Only for that reason the following naïve, but elegant implementation of the fibonacci sequence has O(N) runtime
characteristics, and the result can be computed:

```ruby :include

    let(:fibs1) do 
      cons_stream(0){
        cons_stream(1){
          combine_streams fibs1, fibs1.tail, :+
        }
      }
    end
```

```ruby :example
    expect(fibs1.drop(1000).head)
      .to eq(43466557686937456435688527675040625802564660517371780402481729089536555417949051890403879840079255169295922593080322634775209689623239873322471161642996440906533187938298969649928516003704476137795166849228875)
    
```


## Finite Streams

Finite Streams are implemented the same way LISP imlements lists, by providing an _End_Marker_. What is `nil` in LISP
is `empty_stream` in Ruby. As a matter of fact the `empty_stream` method returns a singleton called `Lab42::Stream::Empty` which
is also accessible via `EmptyStream` if you required the lib with `require 'lab42/stream/auto_import'` which is true for the demos.

Here is an example of a finite stream

```ruby :include
    let(:digits){ finite_stream( 0..9 ) }
```

Now the following all hold

```ruby :example
    expect(digits.drop(9).head).to eq(9)
```

```ruby :example
    expect(digits.drop(10)).to be_empty
```

or alternatively

```ruby :example
    expect(digits.drop(10)).to eq(EmptyStream)
```
