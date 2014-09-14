require 'ostruct'

class SearchContext < OpenStruct
  def initialize(*args)
    super
    validate_presence!([
      :world,
      :agent,
      :target_state,     # this is here because we use it from both agent and searcher
      :allowed_actions,
    ])
  end

private

  def validate_presence!(*keys)
    keys.flatten.each do |key|
      raise ArgumentError, "You must specify #{key}!" unless self.respond_to?(key)
    end
  end
end
