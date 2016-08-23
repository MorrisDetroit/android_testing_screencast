class Hash

  def to_param_keys
    self.inject({}) { |m, (k, v)| m[k.gsub(" ", "_").to_sym] = v; m }
  end

end