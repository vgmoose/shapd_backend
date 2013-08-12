module ActiveRecord::Persistence

  # Update attributes of a record in the database without callbacks, validations etc.
  def update_attributes_without_callbacks(attributes)
    self.assign_attributes(attributes)
    self.class.where(:id => id).update_all(attributes)
  end

  # Update a single attribute in the database
  def update_attribute_without_callbacks(name, value)
    send("#{name}=", value)
    update_attributes_without_callbacks(name => value)
  end

end
