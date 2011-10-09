module GeokitForNamedScopes
  OPTIONS = [:origin, :within, :beyond, :range, :formula, :bounds]

  def find(*args)
    super(*transfer_from_scope_to_args(args))
  end

  def count(*args)
    super(*transfer_from_scope_to_args(args))
  end

  private
    def transfer_from_scope_to_args(args)
      find_options = scope(:find)
      if find_options.is_a?(Hash)
        options = args.extract_options!
        OPTIONS.each do |key|
          options[key] = find_options.delete(key) if find_options.key?(key)
        end
        args << options
      else
        args
      end
    end
end
