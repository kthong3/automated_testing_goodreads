require 'test/unit'
require 'selenium-webdriver'

class LoginTest < Test::Unit::TestCase
  def setup
    # define driver for firefox webdriver
    @driver=Selenium::WebDriver.for :chrome
    # :firefox -> firefox
    # :ie     -> iexplore

    # navigate to the test site
    @driver.navigate.to "https://www.goodreads.com"
  end

  def test_login
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

    # define currently reading header
    currently_reading=@driver.find_element(css: 'h3')

    # check if currently reading header is displayed
    is_currently_reading_displayed=currently_reading.displayed?

    puts is_currently_reading_displayed

    assert_equal(true, is_currently_reading_displayed,'currently reading display')

    assert_equal("currently reading".upcase, currently_reading.text, 'currently reading text')
  end

  def teardown
    # quit the driver
    @driver.quit
  end
end