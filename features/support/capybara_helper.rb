
def patiently_wait_until(timeout_seconds = 10, &block)
  start = Time.now
  while true
    break if block.call
    if Time.now > start + timeout_seconds
      fail 'Timed out while waiting for event to happen'
    end
    sleep 0.1
  end
end
