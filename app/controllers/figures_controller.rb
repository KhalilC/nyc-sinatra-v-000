require 'pry'
require 'bundler/setup'
class FiguresController < ApplicationController

  get '/figures' do
    @figures = Figure.all
    erb :"/figures/index"
  end

  get '/figures/new' do 
    erb :"/figures/new"
  end

  post '/figures' do
    figure = Figure.new
    figure.name = params[:figure][:name]
    new_title = Title.create(name: params[:title][:name]) if params[:title][:name]
    figure.titles << new_title if new_title
    new_landmark = Landmark.create(name: params[:landmark][:name]) if params[:landmark][:name]
    figure.landmarks << new_landmark if new_landmark
    figure.titles << Title.find(params[:figure][:title_ids].join("").to_i) unless params[:figure][:title_ids].nil?
    figure.landmarks << Landmark.find(params[:figure][:landmark_ids].join("").to_i) unless params[:figure][:landmark_ids].nil?
    figure.save    
    redirect '/figures'
  end

  get '/figures/:id' do 
    @figure = Figure.find(params[:id])
    erb :'/figures/show'
  end

  get '/figures/:id/edit' do
    @figure = Figure.find(params[:id])
    erb :'/figures/edit'
  end

  post '/figures/:id' do
    figure = Figure.find(params[:id])
    landmark = Landmark.new
    landmark.name = params[:landmark][:name]
    figure.landmarks << landmark unless params[:landmark][:name].empty?
    figure.name = params[:figure][:name]
    params[:figure][:title_ids].each {|title| figure.titles << Title.find(title.to_i) } unless params[:figure][:title_ids].nil?
    figure.save
    redirect "/figures/#{figure.id}"
  end

end