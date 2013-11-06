require 'spec_helper'
require 'fixtures/classes'
require File.expand_path('../shared/include', __FILE__)

describe "Enumerable#include?" do
  it_behaves_like(:enumerable_include, :include?)
end
