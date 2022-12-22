# frozen_string_literal: true

class BloodGroupsRepresenter
  def initialize(groups)
    @groups = groups
  end

  def as_json
    groups.map do |group|
      {
        id: group.id,
        name: group.name
      }
    end
  end

  private

  attr_reader :groups
end
