# Lab42::Streams Demo

## Finite Helpers


### Splitting finite streams

#### split\_by\_value

Splits a finite stream into finite streams

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





