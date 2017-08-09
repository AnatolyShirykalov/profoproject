class HomeController < ApplicationController
  def index
    @photographs = Tournament.first.photographs
    @juries = Tournament.first.juries
  end
end
