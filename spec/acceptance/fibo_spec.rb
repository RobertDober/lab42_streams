require 'spec_helper'

describe Lab42::Stream do

  let :fib_1000 do
    43466557686937456435688527675040625802564660517371780402481729089536555417949051890403879840079255169295922593080322634775209689623239873322471161642996440906533187938298969649928516003704476137795166849228875
  end

  let :fibs do
    cons_stream( 0 ){ cons_stream( 1 ){ binop_streams(:+, fibs.tail, fibs ) } }
  end
  it "memoizes the promises (thus this spec will not explode memory)" do
    expect(
      fibs.drop(1000).head
    ).to eq( fib_1000 )
  end
end # describe Lab42::Stream
