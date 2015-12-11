require 'aws-sdk'
require 'awspec/resource_reader'
require 'awspec/helper/finder'

module Awspec::Type
  class Base
    include Awspec::Helper::Finder
    include Awspec::BlackListForwardable

    attr_reader :id, :resource_via_client

    def initialize(id = nil)
      @display_name = id
      super
      @id = nil
    end

    def to_s
      type = self.class.name.demodulize.underscore
      "#{type} '#{@display_name}'"
    end

    def inspect
      to_s
    end

    def exists?
      @id
    end

    def method_missing(name)
      describe = name.to_sym
      if @resource_via_client.members.include?(describe)
        @resource_via_client[describe]
      else
        super unless self.respond_to?(:hogehoge)
        method_missing_via_black_list(name, delegate_to: hogehoge)
      end
    end
  end
end
