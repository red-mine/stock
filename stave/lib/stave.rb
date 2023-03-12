require "stave/version"
require "stave/railtie"
require "stave/core_ext"
require "stave/stock"
require "stave/engine"
require "stave/stave"

module Stave
  STOCK = "sz"
  WEEKS = 5
  YEARS = 250
  STAVE = 20  * WEEKS
  LOHAS = 3   * YEARS + YEARS / 2
end
