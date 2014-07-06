# Lab42::Streams Demo

## The Kernel's Stream methods

The first we encountered were `cons_stream` and `empty_stream`. 

### More factory methods

#### finite\_stream

```ruby
      digits = finite_stream 0..9
```

it takes an enumerable and makes it to a stream, one could also use the more OO-like `Enumerable#to\_stream` method if one likes.

of course the following hold:


```ruby
    digits.head.assert.zero?
    digits.entries.assert == [*0..9]

    finite_stream([]).assert.empty?
```

#### const\_stream

Although a constant stream can quite easily be achived as follows

```ruby
    ones = cons_stream( 1 ){ ones }
    ones.drop(100).head.assert == 1
```

the use of a local variable is not always elegant as we will see in the next example, and the whole constuct is a little bit
verbose and less readable as the name `const\_stream` 

```ruby
    integers = cons_stream( 0 ){
      combine_streams integers, const_stream( 1 ), :+
    }

    integers.take( 10 ).assert == digits.entries
    
```
