require 'test/unit'
require 'selenium-webdriver'

class GoodreadsTest < Test::Unit::TestCase
  def setup
    # define driver for firefox webdriver
    @driver=Selenium::WebDriver.for :chrome
    # :firefox -> firefox
    # :ie     -> iexplore

    # navigate to the test site
    @driver.navigate.to 'https://www.goodreads.com'
  end

  def login_user
    # define username field element
    loginUserName=@driver.find_element(:id,'userSignInFormEmail')
    # input user name
    loginUserName.send_keys('kthongsakounh@gmail.com')

    # define password field element
    loginPassword=@driver.find_element(:id,'user_password')
    # input password
    loginPassword.send_keys('g00dr3ads*')

    #define submit button element
    loginSubmitButton=@driver.find_element(:css,'.gr-button.gr-button--dark')
    #click on submit button
    loginSubmitButton.click

    # wait until 'Currently Reading' displays, timeout in 10 seconds
    wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds
    element = wait.until { @driver.find_element(css: 'h3') }
  end

  def search_for_title(title)
    # define search bar field element
    search_bar=@driver.find_element(:xpath,'/html/body/div[3]/div/header/div[2]/div/div[3]/form/input')
    # input partial book title
    search_bar.send_keys(title, :return)

    # wait until search results display, timeout in 10 seconds
    wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds
    search_results = wait.until { @driver.find_element(css: 'h3.searchSubNavContainer') }
  end

  def test_login
    login_user

    # define currently reading header
    currently_reading=@driver.find_element(css: 'h3')

    # check if currently reading header is displayed
    is_currently_reading_displayed=currently_reading.displayed?

    assert_equal(true, is_currently_reading_displayed,'currently reading display')

    assert_equal('currently reading'.upcase, currently_reading.text, 'currently reading text')
  end

  def test_search
    login_user
    search_for_title('harry potter')

    # define search result header "PAGE 1 OF ABOUT"
    search_results=@driver.find_element(css: 'h3.searchSubNavContainer')

    # check if search results header is displayed
    are_search_results_displayed=search_results.displayed?

    assert_equal(true, are_search_results_displayed,'search results display')

    assert_equal(true, search_results.text.include?('PAGE 1 OF ABOUT'), 'search results text')
  end

  def teardown
    # quit the driver
    @driver.quit
  end
end