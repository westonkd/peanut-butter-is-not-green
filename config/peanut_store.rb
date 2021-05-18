# frozen_string_literal: true

class PeanutStore
  def initialize
    @store = [nil]
    @next_id = @store.length
  end

  def find(id)
    raise RecordNotFound unless record_found?(id)

    @store[id]
  end

  def insert!(record)
    @store[@next_id] = record
    @next_id += 1
    @next_id - 1
  end

  def update!(id, new_record)
    raise RecordNotFound unless record_found?(id)

    @store[id] = new_record
  end

  def delete!(id)
    raise RecordNotFound unless record_found?(id)

    @store[id] = nil
  end

  private

  def record_found?(id)
    id < @next_id && !@store[id].nil?
  end

  class RecordNotFound < StandardError; end
end
