class Hash
  def option(attr_name, default)
    delete(attr_name.to_s) || delete(attr_name) || default
  end
end
