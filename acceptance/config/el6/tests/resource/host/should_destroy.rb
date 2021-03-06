test_name "should be able to remove a host record"

agents.each do |agent|
  file = agent.tmpfile('host-destroy')
  line = "127.0.0.7 test1"

  step "set up files for the test"
  on agent, "printf '#{line}\n' > #{file}"

  step "delete the resource from the file"
  on(agent, puppet_resource('host', 'test1', "target=#{file}",
              'ensure=absent', 'ip=127.0.0.7'))

  step "verify that the content was removed"
  on(agent, "cat #{file}; rm -f #{file}") do
    fail_test "the content was still present" if stdout.include? line
  end

  step "clean up after the test"
  on agent, "rm -f #{file}"
end
