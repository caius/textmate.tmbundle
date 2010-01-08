require "osx/cocoa"
include OSX

class UpdatePastieCookie
  URL         = NSURL.URLWithString("http://pastie.org/")
  COOKIE_NAME = "pasties"

  def self.with pastie_id
    return unless self.existing_cookie
    # Create a dictionary (hash) to create the new cookie with
    new_cookie_values = self.existing_cookie.properties.mutableCopy
    # Set our new value
    new_cookie_values[NSHTTPCookieValue] = self.existing_cookie.value + "&#{pastie_id}"
    # Create a new cookie with our attributes
    new_cookie = NSHTTPCookie.cookieWithProperties(new_cookie_values)
    # Set our cookie, overwriting the old one
    self.cookieStorage.setCookie(new_cookie)
  end

  def self.value
    return unless self.existing_cookie
    self.existing_cookie.value
  end

  def self.existing_cookie
    @cookie ||= self.cookieStorage.cookiesForURL(URL).select {|c| c.name == COOKIE_NAME }.first
  end

  def self.cookieStorage
    @storage ||= NSHTTPCookieStorage.sharedHTTPCookieStorage
  end
end
