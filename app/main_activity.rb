class MainActivity < Android::App::Activity
  def onCreate(savedInstanceState)
    super

    @detailed = true

    it "can be constructed to be empty"
    expect{Set.new == Set[]}

    it "can be constructed from enumerables"
    expect{Set.new([1, 2, 3]) == Set[1, 2, 3]}
    it "can be constructed from enumerables - Array"
    expect{[1, 2, 3].to_set == Set[1, 2, 3]}
    it "can be constructed from enumerables - Hash"
    # This fails, creates empty set - probably to do with Hash#to_set
    expect{{a: 1, b: 2}.to_set == Set[[:a, 1], [:b, 2]]}

    it 'can find intersecting set'
    original = Set[1, 2, 3]
    expect{original.intersection([2, 3, 4]) == Set[2, 3]}
    it 'can find intersecting set - original'
    expect{original == Set[1, 2, 3]}

    it 'can find union set'
    expect{Set[1, 2].union(Set[2, 3]) == Set[1, 2, 3]}

    it 'can find set difference'
    expect{Set[1, 2, 3, 4].difference([2, 3]) == Set[1, 4]}

    it 'can add objects'
    set = Set.new
    set.add 1
    set << 2
    expect{set == Set[1, 2]}

    it 'can find exclusive elements'
    expect{(Set[1, 2, 3] ^ Set[2, 3, 4]) == Set[1, 4]}

    it 'can #add? new element'
      set = Set[1, 2]
      expect{(set.add? 3) == set} #Not sure why this one is failing, not retuning correct value?
      expect{set == Set[1, 2, 3]}

    it 'can #add? existing element'
      set = Set[1, 2]
      expect{(set.add? 2) == nil}
      expect{set == Set[1, 2]}

    it 'can #inspect correctly'
      expect{Set[1, 2].inspect == '#<Set: {1, 2}>'}
      # TODO nested sets

    it 'classify itself'
      hash = Set[1, 2, 3, 4].classify { |n| n.odd? ? :odd : :even }
      expect{ hash == {odd: Set[1, 3], even: Set[2, 4]} }


    it 'returns an enumerator when called without block'
      set = Set[1, 2, 3, 4]
      enumerator = set.classify
      expect { enumerator.to_set == Set[1, 2, 3, 4] }
      expect { set == Set[1, 2, 3, 4] }

    results
  end

  # Put into a block so we can capture exceptions as fails
  def expect(&expectation)
    @test_results ||= []
    begin
      result = expectation.call
    rescue Exception => e
      p e.inspect
      result = false
    end

    @test_results << result

    if @detailed == true
      if result == true
        p green("passed")
      else
        p red("failed")
      end
    end

  end

  def it(string)
    p blue(string) if @detailed == true
  end

  def results
    p "Tests have run:"
    passed = 0
    failed = 0
    # .count is not implemented yet as well as .next
    @test_results.each{ |x| passed = passed + 1 if x == true }
    @test_results.each{ |x| failed = failed + 1 if x == false }
    # failed = test_results.count{ |x| x == false }
    p passed.to_s + " tests have passed"
    p failed.to_s + " tests have failed"
  end

  # %w(gray red green yellow blue purple cyan white).each_with_index do |color, i|
  #   define_method color do |str|
  #     "\e[1;#{30+i}m#{str}\e[0m"
  #   end

  #   define_method "#{color}ish" do |str|
  #     "\e[0;#{30+i}m#{str}\e[0m"
  #   end
  # end

  def blue(str)
    i = 4
    color(str,i)
  end

  def green(str)
    i = 2
    color(str,i)
  end

  def red(str)
    i = 1
    color(str,i)
  end

  def color(str, i)
    "\e[1;#{30+i}m#{str}\e[0m"
  end


  def onCreateNetworking(savedInstanceState)
    super

    begin
      puts "started - testbed"
      c = Nexusmotion::Client.new
      url = "https://posttestserver.com/post.php?dir=nexusmotion"
      data = [["id", 33443]]
      result = c.post(url, data)
      puts "Result:"
      puts result
    rescue Exception => e
      p "An error occurred: #{e.inspect}"
    end
  end
end

=begin
describe 'Set' do
  def test(description, &block); it(description, &block) end

  it 'can be constructed with #[]' do
    reference = NSMutableSet.new
    reference.addObject 1
    reference.addObject 2
    reference.addObject 3
    Set[1, 2, 3].should == reference
  end

  it 'can be constructed to be empty' do
    Set.new.should == Set[]
  end

  it 'can be constructed from enumerables' do
    Set.new([1, 2, 3]).should == Set[1, 2, 3]
    [1, 2, 3].to_set.should == Set[1, 2, 3]
    {a: 1, b: 2}.to_set.should == Set[[:a, 1], [:b, 2]]
  end

  it 'can find intersecting set' do
    original = Set[1, 2, 3]
    original.intersection([2, 3, 4]).should == Set[2, 3]
    original.should == Set[1, 2, 3]
  end

  it 'can find union set' do
    Set[1, 2].union(Set[2, 3]).should == Set[1, 2, 3]
  end

  it 'can find set difference' do
    Set[1, 2, 3, 4].difference([2, 3]).should == Set[1, 4]
  end

  it 'can add objects' do
    set = Set.new
    set.add 1
    set << 2
    set.should == Set[1, 2]
  end

  it 'can find exclusive elements' do
    (Set[1, 2, 3] ^ Set[2, 3, 4]).should == Set[1, 4]
  end

  it 'can #add? new element' do
    set = Set[1, 2]
    (set.add? 3).should.equal? set
    set.should == Set[1, 2, 3]
  end

  it 'can #add? existing element' do
    set = Set[1, 2]
    (set.add? 2).should.equal? nil
    set.should == Set[1, 2]
  end

  it 'can #inspect correctly' do
    Set[1, 2].inspect.should == '#<Set: {1, 2}>'
    # TODO nested sets
  end

  describe '#classify' do
    should 'classify itself' do
      hash = Set[1, 2, 3, 4].classify { |n| n.odd? ? :odd : :even }
      hash.should == {odd: Set[1, 3], even: Set[2, 4]}
    end

    should 'returns an enumerator when called without block' do
      set = Set[1, 2, 3, 4]
      enumerator = set.classify
      enumerator.to_set.should == Set[1, 2, 3, 4]
      set.should == Set[1, 2, 3, 4]
    end
  end

  it 'can #clear itself' do
    set = Set[1, 2, 3]
    set.clear.should == Set[]
    set.should == Set[]
  end

  describe '#collect!' do
    should 'map over itself' do
      set = Set[1, 2, 3]
      set.collect! { |item| item * 10 }.should == Set[10, 20, 30]
      set.should == Set[10, 20, 30]
    end

    should 'return enumerator when called without block' do
      set = Set[1, 2, 3]
      enumerator = set.collect!
      enumerator.each { 42 }.to_set.should == Set[42]
      set.should == Set[42]
    end
  end

  it 'can #delete an item from itself' do
    set = Set[1, 2, 3]
    set.delete(2).should == Set[1, 3]
    set.should == Set[1, 3]
  end

  it 'can #delete? when object is present' do
    set = Set[1, 2, 3]
    set.delete?(2).should == Set[1, 3]
    set.should == Set[1, 3]
  end

  it 'can #delete? when object is absent' do
    set = Set[1, 2, 3]
    set.delete?(9).should == nil
    set.should == Set[1, 2, 3]
  end

  describe '#keep_if' do
    should 'return modified self' do
      set = Set[1, 2, 3, 4]
      set.should.equal? set.keep_if { |item| item.odd? }
      set.should == Set[1, 3]
    end

    should 'return enumerator which consumes the set' do
      set = Set[1, 2, 3]
      enumerator = set.keep_if
      enumerator.to_set.should == Set[1, 2, 3]
      set.should == Set[]
    end
  end

  describe '#delete_if' do
    should 'return modified self' do
      set = Set[1, 2, 3, 4]
      set.delete_if { |item| item.odd? }
      set.should == Set[2, 4]
    end

    should 'return enumerator which does *not* consume the set' do
      set = Set[1, 2, 3]
      enumerator = set.delete_if
      enumerator.to_set.should == Set[1, 2, 3]
      set.should == Set[1, 2, 3]
    end
  end

  it 'has #length' do
    Set[1, 2, 3].length.should == 3
  end

  # TODO #devide

  it 'has #each' do
    set = Set[]
    Set[1, 2, 3].each { |item| set << item }
    set.should == Set[1, 2, 3]
  end

  test '#empty?' do
    Set[].empty?.should == true
    Set[1].empty?.should == false
  end

  describe '#flatten' do
    should 'return a flattened set' do
      Set[1, 2, Set[3, Set[4]], 5].flatten.should == Set[1, 2, 3, 4, 5]
    end

    should 'not modifie the original set' do
      set = Set[1, 2, Set[3, Set[4]], 5]
      set.flatten
      set.should == Set[1, 2, Set[3, Set[4]], 5]
    end
  end

  describe '#flatten!' do
    should 'flatten the set in-place' do
      set = Set[1, 2, Set[3, Set[4]], 5]
      set.flatten!.should.equal? set
      set.should == Set[1, 2, 3, 4, 5]
    end

    should 'not flatten an already flat set' do
      set = Set[1, 2, 3]
      set.flatten!
      set.should == Set[1, 2, 3]
    end

    should 'return nil if no modification is made' do
      set = Set[1, 2, 3]
      set.flatten!.should == nil
    end
  end

  test '#include? #member?' do
    Set[1, 2].include?(2).should == true
    Set[1, 2].member?(9).should == false
  end

  test '#merge' do
    set = Set[1, 2, 3]
    set.merge([3, 4, 5]).should.equal? set
    set.should == Set[1, 2, 3, 4, 5]
  end

  test '#subset?' do
    a = Set[1, 2]
    a.subset?(a).should == true
    a.subset?(Set[1, 2, 3]).should == true
    should.raise(ArgumentError) { a.subset?([1, 2, 3]) }
  end

  test '#superset?' do
    a = Set[1, 2, 3]
    a.superset?(a).should == true
    a.superset?(Set[1, 2]).should == true
    should.raise(ArgumentError) { a.superset?([1, 2]) }
  end

  test '#proper_subset?' do
    a = Set[1, 2]
    a.proper_subset?(a).should == false
    a.proper_subset?(Set[1, 2, 3]).should == true
    should.raise(ArgumentError) { a.proper_subset?([1, 2, 3]) }
  end

  test '#proper_superset?' do
    a = Set[1, 2, 3]
    a.proper_superset?(a).should == false
    a.proper_superset?(Set[1, 2]).should == true
    should.raise(ArgumentError) { a.proper_superset?([1, 2]) }
  end

  describe '#reject!' do
    should 'return self when changes are made' do
      set = Set[1, 2, 3]
      set.should.equal? set.reject! { |item| item.even? }
      set.should == Set[1, 3]
    end

    should 'return nil when *no* chages are made' do
      set = Set[1, 2, 3]
      nil.should == set.reject! { |item| item == 42 }
      set.should == Set[1, 2, 3]
    end

    should 'return enumerator when called without block' do
      set = Set[1, 2, 3]
      enumerator = set.reject!
      enumerator.to_set.should == Set[1, 2, 3]
      set.should == Set[1, 2, 3]
    end
  end

  describe '#select!' do
    should 'return self when changes are made' do
      set = Set[1, 2, 3]
      set.should.equal? set.select! { |item| item.odd? }
      set.should == Set[1, 3]
    end

    should 'return nil when *no* chages are made' do
      set = Set[1, 2, 3]
      nil.should == set.select! { |item| item < 42 }
      set.should == Set[1, 2, 3]
    end

    should 'return enumerator when called without block' do
      set = Set[1, 2, 3]
      enumerator = set.select!
      enumerator.to_set.should == Set[1, 2, 3]
      set.should == Set[]
    end
  end




  test '#replace' do
    set = Set[1, 2, 3]
    set.replace([7, 8, 9]).should.equal? set
    set.should == Set[7, 8, 9]
  end

  test '#subtract' do
    set = Set[1, 2, 3]
    set.subtract([2, 4]).should.equal? set
    set.should == Set[1, 3]
  end

  test '#to_a (implemented by Enumerable)' do
    set = Set[1, 2, 3]
    array = set.to_a
    array.class.should == Array
    array.to_set.should == set
  end
end
=end
