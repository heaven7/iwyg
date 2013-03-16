##
# Allows customization for this type of Worker.
# Legal options:
#
#   :queue - use a named queue for this Worker, default 'default'
#   :retry - enable the RetryJobs middleware for this Worker, default *true*
#   :timeout - timeout the perform method after N seconds, default *nil*
#   :backtrace - whether to save any error backtrace in the retry payload to display in web UI,
#      can be true, false or an integer number of lines to save, default *false*

def sidekiq_options(opts={})
  self.sidekiq_options_hash = get_sidekiq_options.merge(stringify_keys(opts || {}))
end

DEFAULT_OPTIONS = { 'retry' => true, 'queue' => 'default' }

def get_sidekiq_options # :nodoc:
  self.sidekiq_options_hash ||= DEFAULT_OPTIONS
end
