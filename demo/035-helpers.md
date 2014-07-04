# Lab42::Streams Demo

## Finite Helpers


### Splitting finite streams

#### split\_by\_value

Splits a stream into streams

##### All resulting streams are finite

```ruby
    sentence = %w{my dear, I said, I know my stuff}.to_stream
    my_oh_my = sentence.split_by_value "my"

    my_oh_my.assert.kinf_of? Stream
    my_oh_my.map(:to_a).to_a.assert == [ %w{my dear, I said, I know}, %w{my stuff} ]
```

There is an option to exclude the splitting element from the result

```ruby
    my_oh_my = sentence.split_by_value "my", exclude: true

    my_oh_my.map(:to_a).to_a.assert == [ %w{dear, I said, I know}, %w{stuff} ]
    
```

The splitting can be done on infinite streams and yields either an infinite stream, or
a finite stream of which the last element is an infinite stream.

The former is the case in the following demo


```ruby
    s = cyclic_stream %w{a b b a b}
    split = s.split_by_value "a"

    split
      .drop(3)
      .take(5)
      .map( :to_a )
      .assert == [ %w{a b}, %w{a b b}, %w{a b}, %w{a b b}, %w{a b} ]
```


The later is the case in this demo

```ruby
    ints = iterate 0, :succ

    split =
      ints.split_by_value 42

    split.head.to_a.assert == [*0..41]
    split.tail.head.drop(1000).take.assert == [1042]
    split.tail.tail.assert.empty?
```




