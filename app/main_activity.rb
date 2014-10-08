class MainActivity < Android::App::Activity
  def onCreate(savedInstanceState)
    super

    begin
      puts "started - testbed"
      c = Nexusmotion::Client.new
      url = "https://ERRORposttestserver.com/post.php?dir=nexusmotion"
      data = [["id", 33443]]
      result = c.post(url, data)
      puts "Result:"
      puts result
    rescue Exception => e
      p "An error occurred: #{e.inspect}"
    end
  end
end
