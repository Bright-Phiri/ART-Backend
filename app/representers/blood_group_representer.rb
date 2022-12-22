# frozen_string_literal: true

class BloodGroupRepresenter
  def initialize(group)
    @group = group
  end

  def as_json
    {
      id: group.id,
      name: group.name
    }
  end

  private

  attr_reader :group
end
