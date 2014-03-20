
def patiently_wait_until(&block)
  start = Time.now
  while true
    break if block.call
    if Time.now > start + 5.seconds
      fail 'Timed out while waiting for event to happen'
    end
    sleep 0.1
  end
end
