class MainActivity < Android::App::Activity
  def onCreate(savedInstanceState)
    super

    begin
      puts "started - testbed"
      c = Nexusmotion::Client.new
      # url = "https://posttestserver.com/post.php?dir=nexusmotion"
      url = "http://httpbin.org/post"
      data = [["id", 33443]]
      result = c.post(url, data)
      puts "Success?:"
      puts result.success?
      puts "Result:"
      puts result.body
      puts "Code:"
      puts result.code
      url = "http://httpbin.org/get"
      result = c.get(url)
      puts "Success?:"
      puts result.success?
      puts "Result:"
      puts result.body
      puts "Code:"
      puts result.code

    rescue Exception => e
      p "An error occurred: #{e.inspect}"
    end
  end
end
