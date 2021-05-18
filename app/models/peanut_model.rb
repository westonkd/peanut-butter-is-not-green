# frozen_string_literal: true

require_relative '../../config/peanut_store'

require 'ostruct'

class PeanutModel
  def initialize(hash)
    @data_object = OpenStruct.new(clean_hash(hash))
  end

  def update!(hash)
    @data_object = OpenStruct.new(
      to_h.merge(clean_hash(hash).reject {|k, _v| k.to_sym == :id})
    )
    self.class.store.update!(id, to_h)
    true
  end

  def destroy!
    self.class.store.delete!(id)
  end

  def method_missing(m, *args, &block)
    @data_object.send(m, *args, &block)
  end

  def respond_to_missing?(method, private = false)
    @data_object.respond_to?(method, private)
  end

  def to_h
    @data_object.to_h
  end

  def as_json
    to_h
  end

  def self.find(id)
    new({id: id}.merge(store.find(id)))
  end

  def self.create!(record)
    id = store.insert!(record)
    new(record.merge({id: id}))
  end

  def self.store
    @@store ||= PeanutStore.new
  end

  def self.fetch_attributes
    @@attributes
  end

  def self.attributes(attrs)
    @@attributes = [:id] + attrs
  end

  private

  def clean_hash(hash)
    hash.reject do |k, _v|
      !self.class.fetch_attributes.include?(k.to_sym)
    end
  end
end
