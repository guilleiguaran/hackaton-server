require File.expand_path('../test_helper', __FILE__)
require 'app'

class AppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    @app ||= App.new
  end

  def test_booth_with_valid_id
    stub_request(:booth_valid_id)
    get '/booths/12345678'

    json = Yajl::Parser.new.parse(last_response.body)
    assert_equal "BARRANQUILLA", json["Municipio:"]
    assert_equal "ATLANTICO", json["Departamento:"]
  end

  def test_booth_with_invalid_id
    stub_request(:booth_not_found_id)
    get '/booths/12345678'

    json = Yajl::Parser.new.parse(last_response.body)
    assert_equal "ID don't found or invalid", json["error"]
  end

  def test_non_selected_jury
    stub_request(:non_selected_jury)
    get '/juries/12345678'

    json = Yajl::Parser.new.parse(last_response.body)
    assert_equal "ID wasn't selected as jury", json["error"]
  end

  def test_selected_jury
    stub_request(:selected_jury)
    get '/juries/12345678'

    json = Yajl::Parser.new.parse(last_response.body)
    assert_equal "ATLANTICO", json["Departamento"]
    assert_equal "BARRANQUILLA", json["Municipio"]
  end

  private

  def stub_request(fixture)
    response = mock('Response')
    response.stubs(:body).returns(fixture(fixture))
    Requests.stubs(:get).returns(response)
  end

  def fixture(fixture)
    File.read(File.join(File.dirname(__FILE__), 'fixtures', "#{fixture}.html"))
  end
end
