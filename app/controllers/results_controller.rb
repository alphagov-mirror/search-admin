class ResultsController < ApplicationController
  def index
  end

  def show
    @path = params[:base_path]
    @path = URI.parse(@path).path if @path.starts_with?('http')

    @document = rummager.get("/content?link=#{@path}")
  end

  def destroy
    rummager.delete!("/content?link=#{params[:id]}")
    flash[:notice] = "This search result will be removed soon. Please refresh this page to check."
    redirect_to result_path("result", base_path: params[:id])
  rescue GdsApi::HTTPNotFound
    flash[:error] = "That URL wasn't found."
    redirect_to results_path
  rescue GdsApi::HTTPClientError => e
    flash[:error] = e.error_details['result']
    redirect_to results_path
  end

private

  def rummager
    SearchAdmin.services(:rummager)
  end
end