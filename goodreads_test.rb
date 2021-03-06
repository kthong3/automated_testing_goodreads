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
  end

  def search_for_title(title)
    search_bar=@driver.find_element(:xpath,'/html/body/div[3]/div/header/div[2]/div/div[3]/form/input')
    search_bar.send_keys(title, :return)
  end

  def select_book_title
    book_title_link=@driver.find_element(css: 'a.bookTitle')
    book_title_link.click
  end

  def test_login
    login_user

    # wait until 'Currently Reading' displays, timeout in 10 seconds
    wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds
    currently_reading = wait.until { @driver.find_element(css: 'h3') }

    # check if currently reading header is displayed
    is_currently_reading_displayed=currently_reading.displayed?

    assert_equal(true, is_currently_reading_displayed,'currently reading display')

    assert_equal('currently reading'.upcase, currently_reading.text, 'currently reading text')
  end

  def test_search
    login_user
    search_for_title('harry potter')

    # wait until search results header "PAGE 1 OF ABOUT", timeout in 10 seconds
    wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds
    search_results = wait.until { @driver.find_element(css: 'h3.searchSubNavContainer') }

    are_search_results_displayed=search_results.displayed?

    assert_equal(true, are_search_results_displayed,'search results display')

    assert_equal(true, search_results.text.include?('PAGE 1 OF ABOUT'), 'search results text')
  end

  def test_select_book_title
    login_user
    search_for_title('harry potter')
    select_book_title

    # wait until book title displays, timeout in 10 seconds
    wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds
    book_title_header = wait.until { @driver.find_element(css: 'h1#bookTitle') }

    # check if book title header is displayed
    book_title_header_displayed=book_title_header.displayed?

    assert_equal(true, book_title_header_displayed,'book title header display')

    assert_equal('Harry Potter and the Sorcerer\'s Stone', book_title_header.text, 'book title header text')
  end

  def test_add_selected_book_title
    login_user
    search_for_title('harry potter')
    select_book_title

    # wait until book title displays before looking for want to read button, timeout in 10 seconds
    wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds
    book_title_header = wait.until { @driver.find_element(css: 'h1#bookTitle') }

    want_to_read_button=@driver.find_element(css: 'button.wtrToRead')
    want_to_read_button.click

    # wait until check mark displays on button, timeout in 10 seconds
    wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds
    check_marked_wtr_button = wait.until { @driver.find_element(css: 'button.wtrStatusToRead.wtrUnshelve') }

    # check if checked marked want to read is displayed
    check_marked_button_displayed=check_marked_wtr_button.displayed?

    assert_equal(true, check_marked_button_displayed,'check mark on want to read button display')
  end

  def teardown
    # quit the driver
    @driver.quit
  end
end