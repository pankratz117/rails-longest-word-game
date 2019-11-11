require 'date'
require 'json'
require 'open-uri'

class GamesController < ApplicationController
  ALPHABET_ARRAY = ('A'..'Z').to_a
  def new
    @letters = Array.new(rand(5..10) { |_| ' ' }).map! { ALPHABET_ARRAY.sample }
    @time_start = Time.now
  end

  def score
    # 1 - calculate the time needed to submit
    @time_needed = Time.now.to_f - params[:time_start].to_f

    # parse the attempt from API
    attempt_hash = JSON.parse(open("https://wagon-dictionary.herokuapp.com/#{params[:word]}").read)

    # 2 - the word cannot be built out of the original grid
    if params[:word].upcase.chars.all? { |c| params[:word].upcase.count(c) <= params[:letters_array].count(c) } == false
      @score = 0
      @message = "Sorry but #{params[:word]} can't be built out of #{params[:letters_array]}"
    # 3 - the word is valid according to the grid, but is not a valid english word
    elsif attempt_hash['found'] == false
      @score = 0
      @message = "Sorry but #{params[:word]} does not seem to be a valid English word..."
    else
      @score = params[:word].length.to_f / @time_needed
      @message = "Congratulations! #{params[:word]} is a valid English word!"
    end
  end
end
