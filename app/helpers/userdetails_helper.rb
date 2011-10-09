module UserdetailsHelper
  def age(dob)
    now = Time.now
  # how many years?
  # has their birthday occured this year yet?
  # subtract 1 if so, 0 if not
    age = now.year - dob.year - (dob.to_time.change(:year => now.year) > now ? 1 : 0)
  end
end
