Given(
/ ^
  (.*)              # I should see
  (t\(([^)]+)\))    # t(self_generated)
  (.*)              # within "#main"
  $
/x) do |first, _, key, last|
  Given %Q[#{first}"#{t(key)}"#{last}]
end